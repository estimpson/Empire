SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [FT].[usp_CSMRawSpendDataAudit(andre)_Moved_to_Monitor_db_in_HN]
AS
BEGIN 
DECLARE @PartList TABLE

(	BasePart VARCHAR(25),
	Part VARCHAR(25),
	ActivePart VARCHAR(25),
	CSMNemonic VARCHAR(50),
	FlattenedRawBOM VARCHAR(MAX)
	PRIMARY KEY (basepart, part)
)

INSERT @PartList
        ( BasePart ,
          Part 
		  )
SELECT LEFT(p.part,7),
		p.part  
FROM part p
WHERE EXISTS (SELECT 1 FROM audit_trail at WHERE date_stamp >=  DATEADD(YEAR, -1 , GETDATE()) AND at.part = p.part) 


DECLARE @ActivepartList TABLE
( ActivePart VARCHAR(25) PRIMARY KEY )


INSERT @ActivepartList (ActivePart) 

SELECT	MAX(blanket_part)
FROM	 [dbo].order_header order_header
WHERE	status = 'A'
GROUP	BY LEFT(blanket_part,7)
UNION
SELECT	MAX(part.part)
FROM	[dbo].part_eecustom part_eecustom
JOIN	[dbo].part part ON part_eecustom.part = part.part
WHERE	ISNULL(part_eecustom.CurrentRevLevel, 'N') = 'Y' AND LEFT(part.part,7) NOT IN (SELECT	DISTINCT LEFT(blanket_part,7)
														FROM	 [dbo].order_header order_header
														WHERE	status = 'A')
GROUP BY LEFT(part.part,7)
 
UPDATE PL
SET 
	PL.Activepart = APL.ActivePart
FROM	
	@PartList PL
JOIN	
	@ActivepartList APL ON APL.ActivePart = PL.Part
 
 DECLARE @BasePartMnemonic TABLE
 (	BasePart VARCHAR(25),
	MNemonic VARCHAR(25),
		 PRIMARY KEY (BasePart, Mnemonic)
)

INSERT @BasePartMnemonic
        ( BasePart, MNemonic )

  SELECT	Base_Part , 
			MNemonic 
FROM		[EEIUser].[acctg_csm_vw_select_sales_forecast] 




DECLARE @BOM TABLE (	BasePart	VARCHAR(25),
						TopPart		VARCHAR(25),
						RawPart		VARCHAR(255),
						QtyPer		NUMERIC(20,6) PRIMARY KEY (TopPart, RawPart))

INSERT @BOM
        ( BasePart, TopPart, RawPart, QtyPer )
SELECT	LEFT(TopPart,7),
			TopPart,
			ChildPart + '( ' + COALESCE(NULLIF(POL.default_vendor,''), 'Not Defined') + ' )',
			Quantity
FROM		[EEHSQL1].[Monitor].[dbo].[vw_RawQtyPerFinPart] BOM JOIN
			[EEHSQL1].[Monitor].[dbo].[part_online] POL ON POL.part = BOM.ChildPart


DECLARE @PartBOM TABLE (BasePart	VARCHAR(25),
						Part		VARCHAR(25),
						RawPart		VARCHAR(255)
						PRIMARY KEY (Part, RawPart))


INSERT @PartBOM
         ( BasePart, Part, RawPart )
SELECT PL.BasePart, 
		PL.Part,
		BOM.RawPart 
	FROM @BOM BOM
 JOIN
	@PartList PL ON PL.BasePart = BOM.BasePart AND PL.Part = BOM.TopPart 




--Flatten CSM Nemonic

DECLARE @BasePart VARCHAR(25),
		@Mnemonics VARCHAR(MAX)

DECLARE @BasePartMnemonicFlat TABLE
 ( Basepart VARCHAR(25),
	Mnemonic VARCHAR(MAX) PRIMARY KEY (Basepart)
)

	DECLARE BasePartList CURSOR LOCAL FOR
	
	SELECT DISTINCT Basepart 
	FROM @BasePartMnemonic

	OPEN BasePartList
	FETCH BasepartList INTO @BasePart

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SELECT @Mnemonics = ''

		SELECT  @Mnemonics = @Mnemonics + Mnemonic + ', '
		FROM	@BasePartMnemonic
		WHERE	BasePart = @BasePart
		GROUP BY
				Mnemonic

		INSERT @BasePartMnemonicFlat
		        ( Basepart, Mnemonic )
		SELECT @BasePart, @Mnemonics

	FETCH BasePartList INTO @BasePart


	END

	CLOSE BasePartList
	DEALLOCATE BasepartList


--Flatten Part BOM

DECLARE @Part VARCHAR(25),
		@RawParts VARCHAR(MAX)

DECLARE @PartBOMFlat TABLE
 (	Part VARCHAR(25),
	RawParts VARCHAR(MAX) PRIMARY KEY (Part)
)

	DECLARE PartList CURSOR LOCAL FOR
	
	SELECT DISTINCT Part
	FROM @PartBOM

	OPEN PartList
	FETCH PartList INTO @Part

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SELECT @RawParts = ''

		SELECT  @RawParts = @RawParts + Rawpart + ', '
		FROM	@PartBOM
		WHERE	Part = @Part
		GROUP BY
				RawPart

		INSERT @PartBOMFlat
		        ( Part, RawParts )
		SELECT @Part, @RawParts

	FETCH PartList INTO @Part


	END

	CLOSE PartList
	DEALLOCATE PartList

TRUNCATE TABLE
	ft.CSMAuditData

INSERT
	ft.CSMAuditData
 
 SELECT 
	PL.Basepart,
	PL.Part,
	PL.ActivePart,
	BPF.Mnemonic,
	FBOM.RawParts
	 
 FROM 
	@PartList PL
 LEFT JOIN
	@BasePartMnemonicFlat BPF ON BPF.Basepart = PL.BasePart
LEFT JOIN
	@PartBOMFlat FBOM ON FBOM.Part = PL.Part

	ORDER BY 1,2
	

END     

--CREATE TABLE ft.CSMAuditData

--(	Basepart VARCHAR(50),
--	Part	VARCHAR(50),
--	ActivePart varchar(50),
--	Mnemonics varchar(max),
--	Rawparts varchar(max)

--	PRIMARY KEY (Part)

--)

GO

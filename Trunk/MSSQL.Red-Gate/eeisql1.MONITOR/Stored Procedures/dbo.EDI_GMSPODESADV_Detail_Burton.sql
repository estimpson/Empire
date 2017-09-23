SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [dbo].[EDI_GMSPODESADV_Detail_Burton] (@Shipper INT, @Serial INT)
 
AS

BEGIN

SET ANSI_PADDING ON 

--dbo.EDI_GMSPODESADV_Detail 3089153
--- Andre S.Boulanger Fore-Thought,LLC 04/01/2016 - Created to accomodate Burton requirement of one DESADV per serial number
---Using TLWForm GMS_DESADV_D_D.97A_GMSPO FT_120309
--Get Part, Object pack_type, Pallet Pack Type Group
--This will be used for CPS Loop.
--CPS03 will be 1 for returnables and expendables that replace returnables. It will be 4 for expandables

--Declare Variables

DECLARE

@CPS INT,
@Part	VARCHAR(25),
@PalletPackCode varchar(20),
@ObjectPackCode varchar(20),
@PackagingIndicator CHAR(1)

--Delare table variable to store part, object pack type, pallet pack type grouping

DECLARE @PartPackTypeSerials TABLE
		(
		 ObjectSerial INT,
		 ParentSerial INT NOT NULL,
		 PalletPackCode VARCHAR(20) NOT NULL,
		 ObjectPackCode VARCHAR(20) NOT NULL,
		 PackagingIndicator Char(1) not null,  
		 Part VARCHAR(25) NOT NULL,
		 ObjectQuantity INT NOT NULL,
		 CustomerPart VARCHAR(30) NOT NULL,
		 CustomerPO VARCHAR(30) NOT NULL,
		 ModelYear VARCHAR(4) NOT NULL,
		 AccumShipped INT NOT NULL,
		 UM CHAR(3) NOT NULL
			PRIMARY KEY (ObjectSerial)
		)	
		
	DECLARE @PalletSerials TABLE
		(
		 PalletSerial INT not NULL,
		 Package_Type varchar(20) not null,
			PRIMARY KEY (PalletSerial)
		)		 
		 	 
		 

-- Insert table variables

Insert @PalletSerials

	SELECT	
				serial PalletSerial, 
				(case when (package_type ='PALLET' or package_type is NULL)  then '0000PALT' else package_type end ) package_type
			FROM
				dbo.audit_trail
			WHERE
				part = 'PALLET' AnD
				type = 'S' AND
				shipper =  CONVERT(VARCHAR(20),@shipper)
				AND EXISTS ( SELECT 1 FROM audit_trail at2 WHERE at2.serial = @Serial AND at2.parent_serial = audit_trail.parent_serial )
	
INSERT	@PartPackTypeSerials
        ( ObjectSerial ,
		  ParentSerial,
		  PalletPackCode ,
          ObjectPackCode ,
          PackagingIndicator,
          Part ,
          ObjectQuantity,
          CustomerPart,
          CustomerPO,
          ModelYear,
          AccumShipped,
          UM
        ) 

SELECT	 at.serial,
		COALESCE(at.parent_serial,0),
		COALESCE(nullif(atp.package_type,''), '0000PALT'),
		COALESCE(nullif(at.package_type,''), '0000CART'),
		 (case when COALESCE(pm0.returnable,'N') = 'Y'  then '1' else '4' end ),                        
		at.part,
		at.quantity,
		COALESCE(sd.customer_Part,''),
		COALESCE(sd.customer_po, ''),
		convert(varchar(2),RIGHT(isNull(nullif(oh.model_year,''), datepart(yy, getdate())),2)),
		sd.accum_shipped,
		'C62'
		
FROM 	
		dbo.audit_trail at
JOIN	shipper_detail sd ON at.part = sd.part_original AND sd.shipper = @shipper
JOIN	order_header oh ON sd.order_no = oh.order_no
left  join
		dbo.package_materials pm0 on oh.package_type = pm0.code
LEFT JOIN	
		dbo.package_materials pm ON at.package_type = pm.code
LEFT JOIN	
	@PalletSerials atp ON at.parent_serial = PalletSerial
LEFT JOIN
		dbo.package_materials ppm ON atp.package_type = ppm.code
WHERE	at.type = 'S' AND
				at.shipper =  CONVERT(VARCHAR(20),@shipper) AND
				at.serial =  COALESCE( @Serial, at.serial)
		
--CREATE temp storage for flat file lines
--Select	* from @PartPackTypeSerials


--Commenting becuase outer procedure will create temp table - This procedure is called by  EDI_GMSPODESADV_Detail
--Create	table	#DESADVFlatFileLines (
--				LineId	int identity,
--				LineData char(80) )
				
-- Get Header for DESADV

Select	
		CONVERT( char(80), '') AS PartialComplete,
		CONVERT( char(80),ISNULL(shipper.ship_via,'')) as bill_of_lading_scac_transfer,
		CONVERT( char(80),ISNULL(bill_of_lading.scac_pickup,'')) AS SCACPickUp,
		CONVERT( char(80),ISNULL(carrier.name,'')) AS CarrierName,
		CONVERT( char(80), ISNULL((case when shipper.freight_type = 'collect' then '1  ' else '2  ' END),'')) AS FreightType,
		convert( char(80), ISNULL(shipper.trans_mode,'')) as TransMode,
		CONVERT( char(80), ISNULL(shipper.staged_pallets,0) ) AS StagedPallets, 
		CONVERT( char(80), ISNULL(SUBSTRING(shipper.aetc_number,3,25),'') ) AS AETCNumber,
		CONVERT( char(80), ISNULL(SUBSTRING(shipper.aetc_number,1,1),'') ) AS AETCNumberReason,
		CONVERT( char(80), ISNULL(SUBSTRING(shipper.aetc_number,2,1),'') ) AS AETCNumberResponsibility,
		CONVERT( char(80), ISNULL(edi_setups.id_code_type,'')) AS IDCodeType,
		CONVERT( char(80), ISNULL(edi_setups.parent_destination,'')) AS ParentDestination, 
		CONVERT( char(80), ISNULL(edi_setups.material_issuer,'')) AS MaterialIssuer,
		CONVERT( char(80), ISNULL(shipper.id,0)) AS ShipperID, 
		CONVERT( char(80), CONVERT(VARCHAR(25), shipper.date_shipped, 112)+LEFT(CONVERT(VARCHAR(25), shipper.date_shipped, 108),2) +SUBSTRING(CONVERT(VARCHAR(25), shipper.date_shipped, 108),4,2)) AS DateShipped,
		CONVERT( char(80), CONVERT(VARCHAR(25), DATEADD(dd, ISNULL(CONVERT(INT,id_code_type),0),shipper.date_shipped), 112)+LEFT(CONVERT(VARCHAR(25), DATEADD(dd, ISNULL(CONVERT(INT,id_code_type),0),shipper.date_shipped), 108),2) +SUBSTRING(CONVERT(VARCHAR(25), DATEADD(dd, ISNULL(CONVERT(INT,id_code_type),0),shipper.date_shipped), 108),4,2)) AS ArrivalDate,
		CONVERT( char(80), CONVERT(VARCHAR(25), GETDATE(), 112)+LEFT(CONVERT(VARCHAR(25), GETDATE(), 108),2) +SUBSTRING(CONVERT(VARCHAR(25), GETDATE(), 108),4,2)) AS ASNDate,
		CONVERT( char(80), ISNULL(edi_setups.pool_code,'')) AS Poolcode, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.gross_weight,0) * .45359237)) AS GrossWeightKG, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.net_weight,0) * .45359237)) AS NetWeightKG, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.gross_weight,0))) AS GrossWeightLBS, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.net_weight,0))) AS NetWeightLBS, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.staged_objs,0))) AS StagedObjs, 
		CONVERT( char(80), ISNULL(shipper.ship_via,'') ) AS SCAC,
		UPPER(CONVERT( char(80), ISNULL(NULLIF(shipper.truck_number,''), 'TruckNo'))) AS TruckNumber, 
		CONVERT( char(80), ISNULL(shipper.pro_number, '')) AS ProNumber, 
		CONVERT( char(80), ISNULL(shipper.seal_number,'')) AS SealNumber, 
		CONVERT( char(80), COALESCE(NULLIF(edi_setups.parent_destination,''), shipper.destination,'')) AS Destination, 
		CONVERT( char(80), ISNULL(shipper.plant,'')) AS Plant,
		CONVERT( char(80), ISNULL(shipper.shipping_dock,'')) AS ShippingDock,
		CONVERT( char(80), COALESCE(shipper.bill_of_lading_number,shipper.id, 0)) AS BOL, 
		CONVERT( char(80), shipper.date_shipped)AS TimeShipped, 
		CONVERT( char(80), ISNULL(bill_of_lading.equipment_initial,'')) AS EquipInitial, 
		CONVERT( char(80), ISNULL(edi_setups.equipment_description,'')) AS EquipDesription, 
		CONVERT( char(80), COALESCE(edi_setups.trading_partner_code,'SPOEDIFACT')) AS TradingPArtnerCode, 
		CONVERT( char(80), ISNULL(edi_setups.supplier_code,'')) AS SupplierCode, 
		CONVERT( char(80), datepart(dy,getdate())) as DayofYr,
		CONVERT( char(80),(isNULL((Select	count(1) From	@PalletSerials ),0))) as pallets,
		CONVERT( char(80),(isNULL((Select	count(1) from	@PartPackTypeSerials WHERE ParentSerial = 0 ),0))) as loose_ctns,
		CONVERT( char(80),0) as loose_bins,
		CONVERT( char(80), ISNULL(edi_setups.parent_destination,'')) as edi_shipto,
		CONVERT( char(80), 'DESADV') AS DocumentType,
		CONVERT( char(80), '') AS ASNOverlayGroup,
		CONVERT( char(80), 'LBR') AS LBR,
		CONVERT( char(80), 'C62') AS C62,
		CONVERT( char(80), 'MB') AS QualMB,
		CONVERT( char(80), '16') AS Qual16,
		CONVERT( char(80), '92') AS Qual92,
		CONVERT( char(80), '12') AS TransQual,
		CONVERT( char(80), '182') AS RESPONSIBLEAGENCY,
		CONVERT( char(80), 'TE') AS EQUIPMENTTYPE,
		CONVERT( char(80), '9') AS MESSAGEFUNCTION,
		CONVERT( char(80), 'G') AS G,
		CONVERT( char(80), 'N') AS N,
		CONVERT( char(80), 'SQ') AS SQ,
		CONVERT( char(80), 'MB') AS MB,
		CONVERT( char(80), '182') AS Code182,
		CONVERT( char(80), '11') AS ShipDateQualifier,
		CONVERT( char(80), '137') AS ASNDateQualifier,
		CONVERT( char(80), '132') AS ArrivalDateQualifier,
		CONVERT( char(80), 'MI') AS MI,
		CONVERT( char(80), 'ST') AS ST,
		CONVERT( char(80), 'SU') AS SU,
		CONVERT( char(80), '92') AS IDType92
		
		
	Into	#DESADVHeaderRaw
	from	shipper
	JOIN	edi_setups ON dbo.shipper.destination = dbo.edi_setups.destination 
	LEFT OUTER JOIN bill_of_lading  ON shipper.bill_of_lading_number = bill_of_lading.bol_number 
	left outer join carrier on shipper.bol_carrier = carrier.scac  
	where	( ( shipper.id = @shipper ) )

	INSERT	#DESADVFlatFileLines (LineData)
	SELECT	('//STX12//X12'+ LEFT(TradingPArtnerCode,12)+LEFT(ShipperID,30)+ LEFT(PartialComplete,1) +LEFT(DocumentType,10) + LEFT(DocumentType,6)+ LEFT(ASNOverlayGroup,3)) FROM #DESADVHeaderRaw
	INSERT	#DESADVFlatFileLines (LineData)
	Select	('01'+ '351' + LEFT(ShipperID,35)  ) FROM #DESADVHeaderRaw
	INSERT	#DESADVFlatFileLines (LineData)
	Select	('02'+ convert(char(3),'137') + left(ASNDate,35) ) FROM #DESADVHeaderRaw
	INSERT	#DESADVFlatFileLines (LineData)
	Select	('02'+ convert(char(3),'11') + LEFT(DateShipped,35) ) FROM #DESADVHeaderRaw
	INSERT	#DESADVFlatFileLines (LineData)
	Select	('03'+ LEFT(G,3) + LEFT(LBR,3)+ LEFT(GrossWeightLBS,16)) FROM #DESADVHeaderRaw
	INSERT	#DESADVFlatFileLines (LineData)
	select	('03'+ LEFT(SQ,3) + LEFT(C62,3)+ LEFT(StagedObjs,16) ) from #DESADVHeaderRaw
	INSERT	#DESADVFlatFileLines (LineData)
	Select	('03'+ LEFT(N,3) + LEFT(LBR,3)+ LEFT(NetWeightLBS,16)) FROM #DESADVHeaderRaw
	INSERT	#DESADVFlatFileLines (LineData)
	select	('04'+  space(35) +  left( MaterialIssuer,35) ) from #DESADVHeaderRaw
	INSERT	#DESADVFlatFileLines (LineData)
	select	('05'+  LEFT(Destination,35) + LEFT(ShippingDock,25)  ) from #DESADVHeaderRaw
	INSERT	#DESADVFlatFileLines (LineData)
	select	('06'+ LEFT(SupplierCode,35) ) from #DESADVHeaderRaw
	INSERT	#DESADVFlatFileLines (LineData)
	select	('07' + LEFT(TransMode,3) + LEFT(SCAC,17) ) from #DESADVHeaderRaw
	INSERT	#DESADVFlatFileLines (LineData)
	select	('08' + LEFT(EQUIPMENTTYPE,3) + left(TruckNumber,17)) from #DESADVHeaderRaw


-- Get Detail for DESADV


SET @CPS = 0		
	
declare
	Part cursor local for
select
	DISTINCT CustomerPart
From
	@PartPackTypeSerials

open
	Part

WHILE
	1 = 1 BEGIN
	
	fetch
		Part
	into
		@Part
			
	IF	@@FETCH_STATUS != 0 BEGIN
		break
	END
	
	SET	@cps = @cps + 1

	INSERT	#DESADVFlatFileLines (LineData)
	SELECT	DISTINCT '09' + CONVERT(CHAR(12), @cps)  + CONVERT(CHAR(03), '4') + CONVERT(CHAR(10),(SELECT COUNT(1) FROM @PartPackTypeSerials WHERE CustomerPart = @part)) + '16 ' + (SELECT MAX(CONVERT(CHAR(35),ProNumber)) FROM #DESADVHeaderRaw )/*+ CONVERT(CHAR(30), PalletPackCode)*/ FROM @PartPackTypeSerials WHERE Customerpart = @part
	
	
	INSERT	#DESADVFlatFileLines (LineData)
	SELECT	'10' + SPACE(6)+ CONVERT(CHAR(35), CustomerPart)  FROM @PartPackTypeSerials WHERE CustomerPart = @part GROUP BY CustomerPart
	
	
	INSERT	#DESADVFlatFileLines (LineData)
	SELECT	'12' + CONVERT(CHAR(3), '12') + CONVERT(CHAR(17), SUM(ObjectQuantity)) +  CONVERT(CHAR(3), MAX(UM)) FROM @PartPackTypeSerials WHERE CustomerPart = @part GROUP BY CustomerPart
	
	INSERT	#DESADVFlatFileLines (LineData)
	SELECT	'12' + CONVERT(CHAR(3), '3') + CONVERT(CHAR(17), MAX(AccumShipped))   + CONVERT(CHAR(3), MAX(UM))  FROM @PartPackTypeSerials WHERE CustomerPart = @part GROUP BY CustomerPart
	
		
	INSERT	#DESADVFlatFileLines (LineData)
	SELECT	'13' + CONVERT(CHAR(3), 'ON') + CONVERT(CHAR(35),CustomerPO ) FROM @PartPackTypeSerials WHERE CustomerPart = @part GROUP BY CustomerPO
	
	

	END	
	
	
CLOSE
	Part
 
DEALLOCATE
	Part
	
	SELECT	(CASE WHEN LEFT(LineData,2) = '14' THEN CONVERT(CHAR(80),LineData) ELSE CONVERT(CHAR(78),LineData) + CONVERT(CHAR(2), LINEID) END)
		
		
	FROM	#DESADVFlatFileLines
	
SET ANSI_PADDING OFF
	
END







GO

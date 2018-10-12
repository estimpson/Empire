SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[HCSP_COMPARE_GL_COST_AUDIT_TRIAL Borrar 11-14]( @FromDate datetime, @ToDate datetime, @Result int = 99999 OUT )
AS

SET @Result = 99999

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
SET NOCOUNT ON

CREATE TABLE [dbo].[#EEH_WW_Audit_Trail](
	[Serial] [int] NOT NULL,
	[Date_stamp] [datetime] NOT NULL,
	[type] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Part] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Quantity] [numeric](20, 6) NULL,
	[Operator] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[from_loc] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[to_loc] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Founded] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mon_Amount] [numeric](20, 6) NULL,
	[Cost_Mon] [numeric](20, 6) NULL,
	[GL_Amount] [numeric](20, 6) NULL
) ON [PRIMARY]


CREATE TABLE [dbo].[#EEH_WW_GL_Cost_Transacction](
	[Document_id1] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Document_id2] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Document_id3] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Document_reference1] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[document_reference2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Quantity] [decimal](18, 6) NULL,
	[Amount] [decimal](18, 6) NULL
) ON [PRIMARY]

SET ANSI_PADDING OFF

INSERT INTO #EEH_WW_Audit_Trail( Serial, Date_stamp, type, Part, Quantity, Operator, from_loc, to_loc  )
SELECT Serial, Date_stamp, type, Part, Quantity, Operator, from_loc, to_loc 
FROM AUDIT_TRAIL
WHERE Date_stamp Between @FromDate and @ToDate and Type IN ('A','M','D','J')
ORDER BY Date_stamp

INSERT INTO #EEH_WW_GL_Cost_Transacction(Document_id1, Document_id2, Document_id3, Document_reference1, document_reference2, Quantity, Amount )
SELECT Document_id1, Document_id2, Document_id3, Document_reference1, document_reference2, Quantity, Amount 
FROM GL_Cost_Transactions
WHERE Transaction_date Between @FromDate and @ToDate and Ledger_account = '152512'

UPDATE #EEH_WW_Audit_Trail
SET  Founded = 'Y', GL_Amount = ABS(Amount)
FROM #EEH_WW_Audit_Trail INNER JOIN #EEH_WW_GL_Cost_Transacction ON #EEH_WW_Audit_Trail.Type = #EEH_WW_GL_Cost_Transacction.Document_ID3 and #EEH_WW_Audit_Trail.Serial = #EEH_WW_GL_Cost_Transacction.Document_ID1

--UPDATE #EEH_WW_Audit_Trail
--SET  Cost_GL = ABS(ISNULL(Cost_GL,0) / Quantity)
--WHERE Quantity <> 0

UPDATE #EEH_WW_Audit_Trail
SET #EEH_WW_Audit_Trail.Mon_Amount = ROUND( isnull(PART_STANDARD.Material_Cum,0) * isnull(#EEH_WW_Audit_Trail.Quantity,0), 2)
FROM #EEH_WW_Audit_Trail INNER JOIN Monitor.dbo.PART_STANDARD PART_STANDARD ON #EEH_WW_Audit_Trail.Part = PART_STANDARD.Part

DELETE FROM EEH_WW_Audit_Trail
INSERT EEH_WW_Audit_Trail( Serial, Date_stamp, type, Part, Quantity, Operator, from_loc, to_loc, Mon_Amount, Cost_Mon, Report_Type, GL_Amount )
SELECT Serial, Date_stamp, type, Part, Quantity, Operator, from_loc, to_loc, Mon_Amount, Cost_Mon, 'Costo Cero', GL_Amount FROM #EEH_WW_Audit_Trail WHERE Founded IS NULL AND Quantity <> 0

INSERT EEH_WW_Audit_Trail( Serial, Date_stamp, type, Part, Quantity, Operator, from_loc, to_loc, Mon_Amount, Cost_Mon, Report_Type, GL_Amount )
SELECT Serial, Date_stamp, type, Part, Quantity, Operator, from_loc, to_loc, Mon_Amount, Cost_Mon, 'Diferencia Cost', GL_Amount FROM #EEH_WW_Audit_Trail WHERE GL_Amount <> Mon_Amount

SET @Result = 0
SET NOCOUNT OFF

GO

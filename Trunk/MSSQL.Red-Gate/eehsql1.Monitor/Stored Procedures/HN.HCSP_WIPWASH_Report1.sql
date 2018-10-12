SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--HN.HCSP_WIPWASH_Report1  @From = '6/5/2008', @To = '6/6/2008'

CREATE PROCEDURE [HN].[HCSP_WIPWASH_Report1]( @From datetime, @To datetime )
AS

CREATE TABLE #GL(
		Serial int,
		date_stamp datetime,
		part varchar(25),
		AU_Type varchar(1),
		Part_type varchar(1),
		Quantity decimal(20,6),
		Amount decimal(20,6))
		
CREATE INDEX idx1_gl ON #GL( AU_Type, Part_type, part, Serial ) 

INSERT  #GL( Serial, date_stamp, part, AU_Type, Part_type, Quantity, Amount )
SELECT	Serial = document_id1,
		Date_stamp = document_id2,
		part = document_reference1,
		Audit_Trail_Type = document_id3,
		Part_type = part.type,
		quantity,
		Amount
FROM	gl_cost_transactions 
		INNER JOIN part 
			ON gl_cost_transactions.document_reference1 = part.part
WHERE	ledger_account='152512' AND 
		transaction_date Between @From AND @To


CREATE	TABLE #Reporte(
	Part varchar(25),
	MI_RM Decimal(20,6),
	MI_WIP Decimal(20,6),
	MI_FG Decimal(20,6),
	DE_WIP Decimal(20,6),
	DE_FG Decimal(20,6),
	JC_WIP Decimal(20,6),
	JC_FG Decimal(20,6),
	MA_RM Decimal(20,6),
	MA_WIP Decimal(20,6),
	MA_FG Decimal(20,6),
	Cost decimal(20,6) DEFAULT 0,
	Level int DEFAULT 0
	)

SELECT TopPart, childpart, xQty
INTO #RawMaterialPart
FROM ft.XRt
WHERE ChildPart IN ( SELECT Part FROM PART WHERE Type = 'R')


CREATE INDEX idx1_report ON #Reporte( Part )

INSERT #Reporte( Part, MI_RM, MA_RM, Cost )
SELECT	Part,
		MI_RM = SUM(CASE WHEN AU_TYPE = 'M' THEN Abs(Quantity) * (Amount/Abs(Amount)) ELSE 0 END),
		MA_RM = SUM(CASE WHEN AU_TYPE = 'A' THEN Abs(Quantity) * (Amount/Abs(Amount)) ELSE 0 END),
		Cost = Sum( HN.fn_GetCostOnDate( Part, Date_stamp ) * Abs(Quantity) * (Amount/Abs(Amount)) )
FROM	#GL GL
WHERE	AU_TYPE IN ('M', 'A') AND GL.Part_type = 'R'
GROUP BY GL.part


INSERT #Reporte( Part, MI_FG,MA_FG,DE_FG,JC_FG,Cost )
SELECT	Part = childpart,
		MI_FG = sum(CASE WHEN AU_TYPE = 'M' THEN Abs(Quantity) * (Amount/Abs(Amount))  * xQty ELSE 0 END),
		MA_FG = sum(CASE WHEN AU_TYPE = 'A' THEN Abs(Quantity) * (Amount/Abs(Amount))  * xQty ELSE 0 END),
		DE_FG = sum(CASE WHEN AU_TYPE = 'D' THEN Abs(Quantity) * (Amount/Abs(Amount))  * xQty ELSE 0 END),
		JC_FG = sum(CASE WHEN AU_TYPE = 'J' THEN Abs(Quantity) * (Amount/Abs(Amount))  * xQty ELSE 0 END),
		Cost = Sum( HN.fn_GetCostOnDate( childpart, Date_stamp ) * Abs(Quantity) * (Amount/Abs(Amount)) * xQty  )
FROM	#GL GL 
		INNER JOIN #RawMaterialPart xrt
		             ON GL.part = Xrt.TopPart
WHERE	GL.Part_type = 'F'		       
GROUP BY childpart

INSERT #Reporte( Part, MI_WIP,MA_WIP,DE_WIP,JC_WIP, Cost )
SELECT	Part = childpart,
		MI_WIP = sum(CASE WHEN AU_TYPE = 'M' THEN Abs(Quantity) * (Amount/Abs(Amount))  * xQty ELSE 0 END),
		MA_WIP = sum(CASE WHEN AU_TYPE = 'A' THEN Abs(Quantity) * (Amount/Abs(Amount))  * xQty ELSE 0 END),
		DE_WIP = sum(CASE WHEN AU_TYPE = 'D' THEN Abs(Quantity) * (Amount/Abs(Amount))  * xQty ELSE 0 END),
		JC_WIP = sum(CASE WHEN AU_TYPE = 'J' THEN Abs(Quantity) * (Amount/Abs(Amount))  * xQty ELSE 0 END),
		Cost = Sum( HN.fn_GetCostOnDate( childpart, Date_stamp ) * Abs(Quantity) * (Amount/Abs(Amount)) * xQty  )
FROM	#GL GL 
		INNER JOIN #RawMaterialPart xrt
		             ON GL.part = Xrt.TopPart
WHERE	GL.Part_type = 'W'		       
GROUP BY childpart

INSERT #Reporte(
	 Part, MI_RM, MA_RM, MI_FG, MA_FG, DE_FG, JC_FG, MI_WIP, MA_WIP, DE_WIP,
	 JC_WIP, Cost, Level )
SELECT	part,
		Sum( MI_RM ),
		SUM( MA_RM ),
		sum( MI_FG ),
		sum( MA_FG ),
		sum( DE_FG ),
		sum( JC_FG ),
		sum( MI_WIP ),
		sum( MA_WIP ),
		sum( DE_WIP ),
		sum( JC_WIP ),
		sum( Cost ),
		1
FROM	#Reporte
GROUP BY PART

DELETE FROM #Reporte WHERE #Reporte.Level =0

/*
UPDATE #Reporte
SET	#Reporte.Cost = PART_STANDARD.material_cum
FROM #Reporte INNER JOIN part_standard ON part_standard.Part = #Reporte.Part


SELECT	PART,
		Total = (ISNULL(MI_RM,0) + 
				ISNULL(MI_WIP,0) + 
				ISNULL(MI_FG,0) + 
				ISNULL(DE_WIP,0) + 
				ISNULL(DE_FG,0) + 
				ISNULL(JC_WIP,0) + 
				ISNULL(JC_FG,0) + 
				ISNULL(MA_RM,0) + 
				ISNULL(MA_WIP,0) + 
				ISNULL(MA_FG,0)),
		Material_cum = COST,
		Total_Cost = (ISNULL(MI_RM,0) + 
				ISNULL(MI_WIP,0) + 
				ISNULL(MI_FG,0) + 
				ISNULL(DE_WIP,0) + 
				ISNULL(DE_FG,0) + 
				ISNULL(JC_WIP,0) + 
				ISNULL(JC_FG,0) + 
				ISNULL(MA_RM,0) + 
				ISNULL(MA_WIP,0) + 
				ISNULL(MA_FG,0)) * Cost,
		MI_RM,
		MI_WIP, MI_FG, DE_WIP, DE_FG, JC_WIP, JC_FG, MA_RM, MA_WIP, MA_FG
FROM	#Reporte
ORDER BY 
		Total_Cost DESC */

SELECT	PART,
		Total = (ISNULL(MI_RM,0) + 
				ISNULL(MI_WIP,0) + 
				ISNULL(MI_FG,0) + 
				ISNULL(DE_WIP,0) + 
				ISNULL(DE_FG,0) + 
				ISNULL(JC_WIP,0) + 
				ISNULL(JC_FG,0) + 
				ISNULL(MA_RM,0) + 
				ISNULL(MA_WIP,0) + 
				ISNULL(MA_FG,0)),
		Material_cum = 0,
		Total_Cost = ISNULL(Cost,0),
		MI_RM,
		MI_WIP, MI_FG, DE_WIP, DE_FG, JC_WIP, JC_FG, MA_RM, MA_WIP, MA_FG
FROM	#Reporte
ORDER BY 
		Total_Cost DESC 
GO

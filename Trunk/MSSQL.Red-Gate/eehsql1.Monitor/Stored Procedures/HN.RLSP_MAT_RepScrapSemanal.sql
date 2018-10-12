SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [HN].[RLSP_MAT_RepScrapSemanal]( @Date1 datetime, @Date2 datetime)
AS


--EXEC HN.Rep_ScrapSemanal '2008-04-14 00:00:00', '2008-04-20 00:00:00'
--
--
--
--DECLARE @Date1 datetime,
--		@Date2 Datetime
--SET @Date1='2008-05-05 00:00:00'
--SET @Date2='2008-05-11 00:00:00'

--Sheet1
SELECT	audit_trail.serial, 
		audit_trail.date_stamp, 
		audit_trail.part, 
		audit_trail.quantity, 
		part.name, 
		audit_trail.operator, 
		audit_trail.notes, 
		part_standard.cost_cum, 
		audit_trail.custom5
INTO #Sheet
FROM	Monitor.dbo.audit_trail audit_trail, Monitor.dbo.part part, Monitor.dbo.part_standard part_standard
WHERE	audit_trail.part = part_standard.part AND part_standard.part = part.part AND 
		(audit_trail.date_stamp>=@Date1 And audit_trail.date_stamp<@Date2) AND 
		(audit_trail.to_loc='S')  AND audit_trail.from_loc <> 'LOST PIBS' AND (audit_trail.remarks NOT LIKE 'Qty%')
		AND audit_trail.notes <> 'Lost Pibs'

		
		
--Locations
SELECT	audit_trail.serial, 
		audit_trail.date_stamp, 
		audit_trail.type, 
		audit_trail.part, 
		audit_trail.quantity, 
		audit_trail.to_loc, 
		audit_trail.from_loc, 
		audit_trail.operator
INTO #location
FROM	Monitor.dbo.audit_trail audit_trail
WHERE	(audit_trail.date_stamp>=@Date1 And audit_trail.date_stamp<@Date2) 
		AND (audit_trail.type='D') 
		AND (audit_trail.from_loc<>'Approved') And (audit_trail.from_loc NOT IN ('Scrap','LOST PIBS'))
		AND (audit_trail.remarks NOT LIKE 'Qty%') AND audit_trail.notes <> 'Lost Pibs'

--Manual add
SELECT	audit_trail.serial, 
		audit_trail.date_stamp, 
		audit_trail.part, 
		audit_trail.quantity, 
		audit_trail.to_loc, 
		audit_trail.from_loc, 
		audit_trail.custom5, 
		audit_trail.notes, 
		audit_trail.operator
INTO #ManualAdd
FROM	Monitor.dbo.audit_trail audit_trail
WHERE	(audit_trail.date_stamp>=@Date2-2) 
		AND (audit_trail.notes='Create with Scrap Program')
		AND audit_trail.type='A'

--Backflush
SELECT	Defects.DefectSerial, 
		Defects.TransactionDT, 
		Defects.Part, 
		Defects.QtyScrapped, 
		Defects.Operator, 
		Defects.Machine, 
		Defects.DefectCode
INTO #Backflush
FROM	Monitor.dbo.Defects Defects
WHERE	(Defects.TransactionDT>=@Date1 And Defects.TransactionDT<@Date2 ) 
		AND (Defects.DefectCode<>'Qty Disc' And Defects.DefectCode<>'Qty Excess')

SELECT	*,
		Area = (SELECT	CASE group_no
						WHEN 'ENSAMBLE' THEN 'Linea'
						WHEN 'Corte-Komax' THEN 'Corte'
						WHEN 'Corte-Sonica' THEN 'Procesos'	
						WHEN 'Corte-Troqmanual-Kits' THEN 'Procesos'
						WHEN 'Corte-Sonica-Kits' THEN 'Procesos'	
						WHEN 'POTTING' THEN 'Potting'
						WHEN 'Manufactura' THEN 'Moldeo'				
						WHEN 'Moldeo' THEN 'Moldeo'	
						WHEN 'Bodega - Corte' THEN 'Bodega'
						WHEN 'Bodega Principal' THEN 'Bodega'
						ELSE
							'Muestras'			
						END 
		        FROM	location 
		        WHERE	code = data.FromLoc),
		Reason2 = (SELECT 	abbreviation_scrap
					FROM	defect_codes
					WHERE	defect_codes.code = data.defect)
								
FROM
	(SELECT	#Sheet.*,
			Defect = isnull((SELECT max(DefectCode)
						FROM	#Backflush
						WHERE	#Backflush.DefectSerial = #Sheet.Serial),
					(SELECT max(custom5)
							FROM	#ManualAdd
							WHERE	#ManualAdd.serial=#Sheet.Serial)),						
			FromLoc = isnull((SELECT max(Machine)
						FROM	#Backflush
						WHERE	#Backflush.DefectSerial = #Sheet.Serial),
						(SELECT max(from_loc)
						FROM	#location
						WHERE	#location.Serial = #Sheet.Serial)),						
			Fecha = isnull((SELECT date_stamp
							FROM	#ManualAdd
							WHERE	#ManualAdd.serial=#Sheet.Serial),
							#Sheet.date_stamp),
			Auditor= isnull((SELECT operator
							FROM	#ManualAdd
							WHERE	#ManualAdd.serial=#Sheet.Serial),
							#Sheet.operator),
			Total=	#sheet.quantity*#sheet.cost_cum		
	FROM	#Sheet ) AS Data
ORDER BY area

DROP table #Backflush
DROP TABLE #Sheet
DROP TABLE #Manualadd
DROP TABLE #Location
GO

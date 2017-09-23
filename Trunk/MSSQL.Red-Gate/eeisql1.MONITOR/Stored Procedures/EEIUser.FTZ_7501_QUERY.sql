SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [EEIUser].[FTZ_7501_QUERY] (@from_date datetime, @through_date datetime)

as

-- Author: DW
-- Date Last Updated: 2014-06-10
-- 
-- Purpose: To identify the inventory removed from the FTZ warehouse at 214 E Maple Rd, Troy, MI  48083 during a given week
--
-- Dependencies: Used in Excel Workbook "S:\Empire FTZ Documents\7501's\2014\01 Empire Electronics Form 7501 Query\01 Empire Electronics Form 7501 Query - Week ended yyyymmdd.xlsx"
-- Dependencies: Excel Workbook data is used as source data for completing weekly CBP Form 7501

 --declare @from_date datetime
 --declare @through_date datetime
 --declare @adj_through_date datetime

 --select @from_date = '2014-06-02 00:00'
 --select @through_date = '2014-06-08 00:00'
 --select @adj_through_date = dateadd(d,1,@through_date)

 --select @from_date
 --select @through_date
 --select @adj_through_date

 
SELECT	at.date_stamp,
		at.type,
		at.from_loc,
		at.to_loc,
		at.custom3,
		at.custom4,
		at.serial,
		at.part,
		at.quantity,
		ps.material_cum,
		at.quantity*ps.material_cum as "Ext_Amount"      
FROM	audit_trail at
	LEFT JOIN   part_standard ps ON at.part = ps.part      
WHERE	at.part<>'PALLET'   		
	AND (at.type in ('S','V') or (at.type = 'Q' and to_loc = 'S'))  		
	AND at.date_stamp >= @from_date
	AND at.date_stamp < dateadd(d,1,@through_date)  		
	AND isnull(at.custom4,'') <> ''   
ORDER BY	at.type,at.part
GO

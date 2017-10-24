SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create  view [dbo].[vw_eei_AND001_object_hist_diff]
as
Select	(CASE WHEN (isNULL(Serial200709,0)>isNULL(Serial200708,0))  THEN 'Addition' WHEN (isNULL(Serial200709,0)<isNULL(Serial200708,0)) THEN 'Reduction' ELSE 'Same' END)as INVMove,  
		* 
from
(select	isNULL(Serial,0) Serial200708, 
		object_historical.Fiscal_year FY200708, 
		object_historical.period P200708,
		quantity QTY200708,
		cost_cum cost200708,
		object_historical.part Part200708
		
from	object_historical 
join		part_standard_historical on object_historical.part  = part_standard_historical.part and object_historical.period  = part_standard_historical.period and object_historical.fiscal_year  = part_standard_historical.fiscal_year 
where	object_historical.part like 'AND0001-HC02%' 
and		object_historical.fiscal_year = 2007 and object_historical.period in (8)) SnapShot20070831 full join
(select	isNULL(Serial,0) Serial200709, 
		object_historical.Fiscal_year, 
		object_historical.period,
		quantity,
		cost_cum,
		object_historical.part
		
from	object_historical 
join		part_standard_historical on object_historical.part  = part_standard_historical.part and object_historical.period  = part_standard_historical.period and object_historical.fiscal_year  = part_standard_historical.fiscal_year 
where	object_historical.part like 'AND0001-HC02%' 
and		object_historical.fiscal_year = 2007 and object_historical.period in (9)) SnapShot20070930 on SnapShot20070831.Serial200708 = SnapShot20070930.Serial200709

GO

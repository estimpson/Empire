SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [HN].[vw_FifoOnHold_Object]
AS

SELECT			
	o.serial, 
	o.part, 
	o.location, 
	o.last_date, 
	o.status, 
	o.quantity,
	o.parent_serial,
	o.Shipper,
	weeks_on_stock=case when datediff(week,o.ObjectBirthday,getdate())>12 then 13 else datediff(week,o.ObjectBirthday,getdate()) end,
	weeks_on_stock_original=datediff(week,o.ObjectBirthday,getdate()),
--	plant= locationValid.plant, -- isnull(case when l.group_no like '%warehouse%' then ltrim(rtrim(replace(l.group_no,'warehouse',''))) else  l.plant end,l.plant),
	CrossRef = Part.Cross_ref,
	IsFullStdPack = case when isnull(pinv.standard_pack,-1) = o.quantity then 1 else 0 end,
	o.ObjectBirthday
FROM MONITOR.dbo.object o with (readuncommitted)
	inner join monitor.dbo.part Part with (readuncommitted)
		 on Part.part = o.part
	inner join monitor.dbo.part_inventory PInv
		 on PInv.part = o.part
WHERE	o.status='H' 
		and o.quantity>0				
		and o.location not like '%FIS'
		and o.location not like '%-%F'
		and o.location not like 'QC%'

GO

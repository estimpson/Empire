SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










/*
Select	*
from	[HN].[vw_Picklist_Object]
where	plant='EEI'
*/
CREATE view [HN].[vw_Picklist_Object]
AS
SELECT			
	o.serial, 
	o.part, 
	o.location, 
	o.last_date, 
	o.status, 
	o.quantity,
	o.parent_serial,
	locationvalid.group_no, 
	Shipper = case when location like 'ran-%' then o.ShipperToRAN else o.Shipper end,
	weeks_on_stock=case when datediff(week,o.ObjectBirthday,getdate())>12 then 13 else datediff(week,o.ObjectBirthday,getdate()) end,
	weeks_on_stock_original=datediff(week,o.ObjectBirthday,getdate()),
	plant= locationValid.plant, -- isnull(case when l.group_no like '%warehouse%' then ltrim(rtrim(replace(l.group_no,'warehouse',''))) else  l.plant end,l.plant),
	CrossRef = Part.Cross_ref,
	IsFullStdPack = case when isnull(pinv.standard_pack,-1) = o.quantity then 1 else 0 end,
	o.ObjectBirthday
FROM MONITOR.dbo.object o with (readuncommitted)
	inner join monitor.dbo.part Part with (readuncommitted)
		 on Part.part = o.part
	inner join monitor.dbo.part_inventory PInv
		 on PInv.part = o.part
	inner join (Select	code, plant = ltrim(rtrim(replace(plant,'TRAN-',''))), group_no
				from	location with (readuncommitted)
				where	( plant like '%eei%'
						or plant like '%eea%'
						or plant like '%eep%')
						and ((group_no like '%warehouse%' and isnull(secured_location,'N')='N') 
								or (group_no in ('FINISHED GOODS')))
				union all
				Select	*, group_no=''
				from (
				Select	distinct location
				from object
				where	location like 'tran%'
					and quantity>0
					and status='A'
					and part <> 'PALLET') TransLocation 
					cross join ( Select Plant='EEI' union all 
								 Select Plant='EEA' union all 
								 Select Plant='EEP') Data
						) LocationValid
		on LocationValid.code = o.location
WHERE	o.status='a' 
		and o.quantity>0				
		and o.location not like '%FIS'
		and o.location not like '%-%F'
		--and o.location not like '%ran%'
















GO

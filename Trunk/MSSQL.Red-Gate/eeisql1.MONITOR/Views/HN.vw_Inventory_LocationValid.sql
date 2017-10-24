SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE view [HN].[vw_Inventory_LocationValid]
 as

 Select	code, plant = ltrim(rtrim(replace(plant,'TRAN-',''))), group_no
 				from	location with (readuncommitted)
					inner join	location_limits limits
						 on location.code = limits.location_code
				where	( plant like '%eei%'
						or plant like '%eea%'
						or plant like '%eep%')
						and code not like '%stage%' 
						and code not like '%ran-%' 
						and code not like '%LTL-CLAIMS%' 
GO

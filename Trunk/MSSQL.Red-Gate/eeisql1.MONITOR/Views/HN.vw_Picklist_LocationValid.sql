SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Select *
--from [HN].[vw_Picklist_LocationValid]

 CREATE view [HN].[vw_Picklist_LocationValid]
 as

 Select	code, plant = ltrim(rtrim(replace(plant,'TRAN-',''))), group_no
 --, Aisle = Substring (location.code, 1, 1),
	--Shelf = convert (int, Substring (location.code, 3, 1)),
	--Subshelf = convert (int, Substring (location.code, 5, 2))
				from	location with (readuncommitted)
				where	( plant like '%eei%'
						or plant like '%eea%'
						or plant like '%eep%'
						or plant like '%eeg%')
						and ((group_no like '%warehouse%' and isnull(secured_location,'N')='N') 
								or (group_no in ('FINISHED GOODS')))

GO

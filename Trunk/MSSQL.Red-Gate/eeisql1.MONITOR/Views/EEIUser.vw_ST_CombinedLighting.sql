SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [EEIUser].[vw_ST_CombinedLighting]
as
select
	scl.ID
,	scl.VehiclePlantMnemonic
,	scl.Country
,	scl.ProductionBrand
,	scl.Program
,	convert(varchar, scl.Sop, 101) as Sop
,	scl.BulbType
,	scl.Application
,	scl.Customer
,	scl.ComponentVolume2017
,	scl.ComponentVolume2018
,	scl.ComponentVolume2019
,	scl.ComponentVolume2020
,	scl.ComponentVolume2021
,	derTbl.TotalComponentVolume
,	isnull((derTbl.TotalComponentVolume * sclp.AveragePrice), 0) as TotalSales
from
	EEIUser.ST_CombinedLighting scl
	left join (	select
					ID
				,	BulbType
				,	(isnull(scl2.ComponentVolume2017, 0) + isnull(scl2.ComponentVolume2018, 0) + 
						isnull(scl2.ComponentVolume2019, 0) + isnull(scl2.ComponentVolume2020, 0) +
						isnull(scl2.ComponentVolume2021, 0) ) as TotalComponentVolume
				from
					EEIUser.ST_CombinedLighting scl2 ) as derTbl
		on derTbl.ID = scl.ID
	left join EEIUser.ST_CombinedLighting_Pricing sclp
		on sclp.BulbType = (scl.BulbType + ' ' + scl.Application)
GO

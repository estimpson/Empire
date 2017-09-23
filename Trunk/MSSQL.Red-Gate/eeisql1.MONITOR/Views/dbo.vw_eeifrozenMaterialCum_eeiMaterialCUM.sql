SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	view [dbo].[vw_eeifrozenMaterialCum_eeiMaterialCUM]
as

Select	eeips.part EEIPart,
		eeips.frozen_material_cum EEIFrozenMaterialCUM,
		eehps.material_cum EEHMaterialCum
from	part_standard eeips
join	part on eeips.part = part.part
left join	[EEHSQL1].[EEH].[dbo].part_standard eehps on eeips.part = eehps.part /*and eehps.time_stamp  = (Select max(time_stamp) from [EEHSQL1].[EEH].[dbo].part_standard_historical where period = 6 and fiscal_year = 2009)*/
where	(eeips.frozen_material_cum is Null or eeips.frozen_material_cum = 0) and
		part.class = 'P' and
		part.type = 'F' /*and eeips.part in (select part from object) where time_stamp = (Select max(time_stamp) from object_historical where period = 6 and fiscal_year = 2009))*/
		
GO

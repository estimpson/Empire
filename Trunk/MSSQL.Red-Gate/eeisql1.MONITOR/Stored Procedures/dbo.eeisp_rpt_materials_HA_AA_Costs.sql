SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	procedure	[dbo].[eeisp_rpt_materials_HA_AA_Costs]
as
select	TopPart, ChildPart, Sum(XQty)as Quantity
into #XRoute
from FT.XRT
		JOIN	part on FT.XRT.TopPart = Part.part
		JOIN	part P2 on FT.XRT.ChildPart =P2.part
Where	part.type = 'F' and TopPart !=ChildPart and ChildPart like '%[-]H%' and Toppart like '%[-]A%' and TopPart in ('NAL0040-AB03','NAL0068-AB00','NAL0074-AA00','NAL0074-AA01','NAL0103-AC00','NAL0103-AC01','NAL0104-AC00','NAL0104-AC01')
GROUP	BY TopPart, ChildPart



Select	eeips.part EEIPart,
		eeips.frozen_material_cum EEIFrozenMaterialCUM,
		eehps.material_cum EEHMaterialCum,
		eeips.material_cum as EEIMaterialCUM,
		eeips.price as EEIPrice,
		eehps.price as EEHPrice
		
from	part_standard_historical eeips
join	part on eeips.part = part.part
left join	[EEHSQL1].[EEH].[dbo].part_standard_historical eehps on eeips.part = eehps.part and eehps.time_stamp  = (Select max(time_stamp) from [EEHSQL1].[EEH].[dbo].part_standard_historical where period = 5 and fiscal_year = 2009)
join	#XRoute XR2 on eehps.part = XR2.Childpart
where	eeips.time_stamp = (Select max(time_stamp) from part_standard_historical where period = 5 and fiscal_year = 2009)

GO

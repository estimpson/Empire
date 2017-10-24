SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure  [FT].[Ftsp_SpaceIndentedBOMPerPartRawOnly] (@part varchar(25))

--
--FT.Ftsp_SpaceIndentedBOMPerPart 'ALC0001-HF08'

as

select	
	BOM = (CASE WHEN XRT.TopPart = XRT.ChildPart THEN SPACE(0) ELSE Space(3) END) + XRt.ChildPart,
	PartClassification = (CASE WHEN class = 'P' THEN 'Purchased' WHEN class = 'M' THEN 'Manufactured' ELSE 'Other' END),
	BOMDescription = part.name,
	Commodity = part.commodity,
	Qty = (CASE WHEN XRT.TopPart = XRT.ChildPart THEN 1 ELSE BOM.quantity END) ,
	Unit = ( CASE WHEN XRT.TopPart = XRT.ChildPart THEN 'EA'  ELSE BOM.unit_measure END),
	ScrapFactor = BOM.scrap_factor,
	MaterialCum = material_cum,
	ExtendedMaterialCUM = (CASE WHEN XRT.TopPart = XRT.ChildPart THEN SPACE(0) ELSE Space(3) END) + CONVERT (varchar(15), material_cum*(CASE WHEN XRT.TopPart = XRT.ChildPart THEN 1 ELSE BOM.quantity END)),
	PrimaryVendor = default_vendor,
	Machine = PM.machine,
	PPH = PM.parts_per_hour,
	ActivityCode = AR.code
from	FT.XRt XRT
	join part on XRt.ChildPart = part.part
	JOIN part_online on part.part = part_online.part
	JOIN	part_standard ON part.part = part_standard.part
	left join dbo.bill_of_material_ec BOM on XRt.BOMID = BOM.ID
	left join dbo.part_machine PM on XRt.ChildPart = PM.part and
		PM.sequence = 1
	left join dbo.activity_router AR on XRt.ChildPart = AR.parent_part
where	XRt.TopPart in (select part from dbo.part where type = 'F') AND
			XRT.Childpart IN (SELECT part FROM dbo.part WHERE type = 'R' OR part.part = @part) and
		XRt.TopPart = @Part
order by
	XRt.TopPart,
	XRt.Sequence
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure  [FT].[Ftsp_SpaceIndentedBOMPerPart] (@part varchar(25))

--
--FT.Ftsp_SpaceIndentedBOMPerPart 'ALC0001-HF08'

as

select	FinishedGood = XRt.TopPart,
	BOM = Space(XRt.BOMLevel * 5) + XRt.ChildPart,
	BOMDescription = part.name,
	Commodity = part.commodity,
	Qty = BOM.quantity,
	Unit = BOM.unit_measure,
	ScrapFactor = BOM.scrap_factor,
	Machine = PM.machine,
	PPH = PM.parts_per_hour,
	ActivityCode = AR.code,
	MaterialCum = material_cum,
	ExtendedMaterialCUM = material_cum* BOM.quantity,
	CostCum = cost_cum,
	ExtendedCostCum = cost_cum*BOM.Quantity,
	PrimaryVendor = default_vendor,
	
	PartClassification = (CASE WHEN class = 'P' THEN 'Purchased' WHEN class = 'M' THEN 'Manufactured' ELSE 'Other' END)
from	FT.XRt XRT
	join part on XRt.ChildPart = part.part
	JOIN part_online on part.part = part_online.part
	JOIN	part_standard ON part.part = part_standard.part
	left join dbo.bill_of_material_ec BOM on XRt.BOMID = BOM.ID
	left join dbo.part_machine PM on XRt.ChildPart = PM.part and
		PM.sequence = 1
	left join dbo.activity_router AR on XRt.ChildPart = AR.parent_part
where	XRt.TopPart in (select part from dbo.part where type = 'F') and
		XRt.TopPart = @Part
order by
	XRt.TopPart,
	XRt.Sequence
GO

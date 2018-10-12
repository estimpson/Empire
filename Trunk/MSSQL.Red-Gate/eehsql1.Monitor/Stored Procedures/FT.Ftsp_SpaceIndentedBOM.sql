SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Procedure  [FT].[Ftsp_SpaceIndentedBOM]


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
	ActivityCode = AR.code
from	FT.XRt XRT
	join part on XRt.ChildPart = part.part
	left join dbo.bill_of_material_ec BOM on XRt.BOMID = BOM.ID
	left join dbo.part_machine PM on XRt.ChildPart = PM.part and
		PM.sequence = 1
	left join dbo.activity_router AR on XRt.ChildPart = AR.parent_part
where	XRt.TopPart in (select part from dbo.part where type = 'F') 
order by
	XRt.TopPart,
	XRt.Sequence
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE Procedure  [FT].[Ftsp_BOMPerPart] (@part varchar(25))

--
--FT.Ftsp_BOMPerPart 'NAL0159-ASA07'

as

select	FinishedGood = XRt.TopPart,
	PrimaryVendor = default_vendor,
	BOM = XRt.ChildPart,
	BOMDescription = part.name,
	Commodity = part.commodity,
	--class,
	PartClassification = (CASE WHEN class = 'P' THEN 'Purchased' WHEN class = 'M' THEN 'Manufactured' ELSE 'Other' END)	,
	Qty = sum(XRt.XQty),
	UOM = BOM.unit_measure,
	ScrapFactor = BOM.scrap_factor,
	MaterialCum = avg(material_cum),
	ExtendedMaterialCUM = avg(material_cum)*sum(XRt.XQty)

from	FT.XRt XRT
	join part on XRt.ChildPart = part.part
	JOIN part_online on part.part = part_online.part
	JOIN	part_standard ON part.part = part_standard.part
	left join dbo.bill_of_material_ec BOM on XRt.BOMID = BOM.ID
	left join dbo.part_machine PM on XRt.ChildPart = PM.part and
		PM.sequence = 1
	left join dbo.activity_router AR on XRt.ChildPart = AR.parent_part
where	XRt.TopPart in (select part from dbo.part where type = 'F') and
		XRt.TopPart = @part
		and class <> 'M'
		
group by XRt.TopPart, XRt.ChildPart, part.name, part.commodity, BOM.unit_measure, BOM.scrap_factor, default_vendor, class

order by
	XRt.TopPart, Default_vendor, XRt.ChildPart





GO

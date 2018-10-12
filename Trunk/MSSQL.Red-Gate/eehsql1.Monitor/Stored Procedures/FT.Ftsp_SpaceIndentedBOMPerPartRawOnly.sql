SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Procedure  [FT].[Ftsp_SpaceIndentedBOMPerPartRawOnly] (@part varchar(25))

--
--FT.Ftsp_SpaceIndentedBOMPerPartRawOnly 'VSL0124-HA03'

as

select	
	BOM = (CASE WHEN XRT.TopPart = XRT.ChildPart THEN SPACE(0) ELSE Space(3) END) + XRt.ChildPart,
	BOMDescription = part.name,	
	Commodity = part.commodity,	
	PartClassification = (CASE WHEN class = 'P' THEN 'Purchased' WHEN class = 'M' THEN 'Manufactured' ELSE 'Other' END),
	DefaultVendor = default_vendor,
	StandardPack = standard_pack,
	LeadTime = lead_time,
	Qty = (CASE WHEN XRT.TopPart = XRT.ChildPart THEN 1 ELSE suM(BOM.quantity) END) ,
	Unit = ( CASE WHEN XRT.TopPart = XRT.ChildPart THEN 'EA'  ELSE BOM.unit_measure END),
	ScrapFactor = BOM.scrap_factor,
	MaterialCum = material_cum,
	ExtendedMaterialCUM = (CASE WHEN XRT.TopPart = XRT.ChildPart THEN SPACE(0) ELSE Space(3) END) + CONVERT (varchar(15), sum(material_cum*(CASE WHEN XRT.TopPart = XRT.ChildPart THEN 1 ELSE BOM.quantity END))),
	(select SUM(quantity) from object where part = XRt.ChildPart and Status = 'A') as good_quantity_on_hand,
	(select SUM(quantity) from object where part = XRT.ChildPart and Status = 'H') as on_hold_quantity_on_hand,
	Machine = PM.machine,
	PPH = PM.parts_per_hour,
	ActivityCode = AR.code
from	FT.XRt XRT
	join part on XRt.ChildPart = part.part
	JOIN part_online on part.part = part_online.part
	JOIN part_vendor on part_vendor.part = XRT.ChildPart and part_vendor.vendor = part_online.default_vendor
	JOIN part_inventory on part_inventory.part = XRT.ChildPart
	JOIN part_standard on part.part = part_standard.part
	left join dbo.bill_of_material_ec BOM on XRt.BOMID = BOM.ID
	left join dbo.part_machine PM on XRt.ChildPart = PM.part and PM.sequence = 1
	left join dbo.activity_router AR on XRt.ChildPart = AR.parent_part
where	XRt.TopPart in (select part from dbo.part where type = 'F') 
	and	XRT.Childpart IN (SELECT part FROM dbo.part WHERE type = 'R' OR part.part = @part) 
	and	XRt.TopPart = @Part
group by 
	XRT.TopPart,
	XRT.ChildPart,
	part.name,	
	part.commodity,	
	(CASE WHEN class = 'P' THEN 'Purchased' WHEN class = 'M' THEN 'Manufactured' ELSE 'Other' END),
	default_vendor,
	standard_pack,
	lead_time,
	(CASE WHEN XRT.TopPart = XRT.ChildPart THEN 'EA'  ELSE BOM.unit_measure END),
	BOM.scrap_factor,
	material_cum,
	PM.machine,
	PM.parts_per_hour,
	AR.code
	
order by
	XRt.TopPart,
	DefaultVendor

GO

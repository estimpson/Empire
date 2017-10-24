SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FT].[vwBasePartSetups_General]
as
select	BasePart = BaseParts.BasePart,
	ECNs = count (distinct PartPasePart_Crossref.PartECN),
	Description = max (BaseParts.Description),
	DescriptionMatch = case when isnull (min (part.name), '@') = isnull (max (part.name), '@') then 1 else 0 end,
	Crossref = max (part.cross_ref),
	CrossrefMatch = case when isnull (min (part.cross_ref), '@') = isnull (max (part.cross_ref), '@') then 1 else 0 end,
	Class = max (part.class),
	ClassMatch = case when isnull (min (part.class), '@') = isnull (max (part.class), '@') then 1 else 0 end,
	Type = max (part.type),
	TypeMatch = case when isnull (min (part.type), '@') = isnull (max (part.type), '@') then 1 else 0 end,
	ProductLine = max (part.product_line),
	ProductMatch = case when isnull (min (part.product_line), '@') = isnull (max (part.product_line), '@') then 1 else 0 end,
	Commodity = max (part.commodity),
	CommodityMatch = case when isnull (min (part.commodity), '@') = isnull (max (part.commodity), '@') then 1 else 0 end,
	GroupTechnology = max (part.group_technology),
	GroupTechnologyMatch = case when isnull (min (part.group_technology), '@') = isnull (max (part.group_technology), '@') then 1 else 0 end,
	QualityAlert = max (part.quality_alert),
	QualityAlertMatch = case when isnull (min (part.quality_alert), '@') = isnull (max (part.quality_alert), '@') then 1 else 0 end,
	SerialType = max (part.serial_type),
	SerialTypeMatch = case when isnull (min (part.serial_type), '@') = isnull (max (part.serial_type), '@') then 1 else 0 end,
	InventoryClass = max (part.user_defined_1),
	InventoryClassMatch = case when isnull (min (part.user_defined_1), '@') = isnull (max (part.user_defined_1), '@') then 1 else 0 end,
	InternalRevLvl = max (part.user_defined_2),
	InternalRevLvlMatch = case when isnull (min (part.user_defined_2), '@') = isnull (max (part.user_defined_2), '@') then 1 else 0 end,
	DrawingNumber = max (part.drawing_number),
	DrawingNumberMatch = case when isnull (min (part.drawing_number), '@') = isnull (max (part.drawing_number), '@') then 1 else 0 end
from	FT.BaseParts BaseParts
	left join FT.vwPartBasePart_Crossref PartPasePart_Crossref on BaseParts.BasePart = PartPasePart_Crossref.BasePart
	left join part on PartPasePart_Crossref.PartECN = part.part
group by
	BaseParts.BasePart
GO

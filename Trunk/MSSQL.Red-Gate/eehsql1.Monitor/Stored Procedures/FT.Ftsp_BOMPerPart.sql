SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--**DO NOT CHANGE THIS QUERY WITHOUT DW APPROVAL!!!!**


CREATE procedure [FT].[Ftsp_BOMPerPart] (@part varchar(25))

--
--FT.Ftsp_BOMPerPart 'VNA0159-HC04'

as
select
	FinishedGood = XRT.TopPart
,	PrimaryVendor = default_vendor
,	LeadTime = max(lead_time)
,	RealLeadTime = max(real_lead_time)
,	BOM = XRT.ChildPart
,	BOMDescription = part.name
,	Commodity = part.commodity
--class,
,	PartClassification = (case
							  when class = 'P' then
								  'Purchased'
							  when class = 'M' then
								  'Manufactured'
							  else
								  'Other'
						  end
						 )
,	Qty = sum(XRT.XQty)
,	UOM = BOM.unit_measure
,	ScrapFactor = BOM.scrap_factor
,	MaterialCum = avg(material_cum)
,	ExtendedMaterialCUM = avg(material_cum) * sum(XRT.XQty)
,	SPI_MasterialAccum = avg(spsSPI.MaterialAccum) * sum(XRT.XQty)
,	SPI_LaborAccum = avg(spsSPI.LaborAccum) * sum(XRT.xQty)
,	SPI_BurdenAccum = avg(spsSPI.BurdenAccum) *sum(XRT.XQTY)
,	CN_MasterialAccum = avg(spsCN.MaterialAccum) * SUM(XRT.XQTY)
,	CN_LaborAccum = avg(spsCN.LaborAccum) * sum(XRT.XQTY)
,	CN_BurdenAccum = avg(spsCN.BurdenAccum) * sum(XRT.XQTY)
from
	FT.XRt XRT
	join part
		on XRT.ChildPart = part.part
	join part_online
		on part.part = part_online.part
	left join part_vendor
		on part_vendor.part = part.part
		and part_vendor.vendor = part_online.default_vendor
	join part_standard
		on part.part = part_standard.part
	left join dbo.PartStandard_SPI spsSPI
		on spsSPI.Part = XRT.ChildPart
	left join dbo.PartStandard_CN spsCN
		on spsCN.Part = XRT.TopPart
	left join dbo.bill_of_material_ec BOM
		on XRT.BOMID = BOM.ID
	left join dbo.part_machine PM
		on XRT.ChildPart = PM.part
		   and PM.sequence = 1
	left join dbo.activity_router AR
		on XRT.ChildPart = AR.parent_part
where
	XRT.TopPart in
	(
		select
			part
		from
			dbo.part
		where
			type = 'F'
	)
	and XRT.TopPart = @part
	and class <> 'M'
group by
	XRT.TopPart
,	XRT.ChildPart
,	part.name
,	part.commodity
,	BOM.unit_measure
,	BOM.scrap_factor
,	default_vendor
,	class
order by
	XRT.TopPart
,	default_vendor
,	XRT.ChildPart;



GO

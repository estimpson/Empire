SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [FT].[Ftsp_BOMPerPart_Graph] (@part varchar(25))

--
-- FT.Ftsp_BOMPerPart_Graph 'NOR0047-HB01'

as
select
--	FinishedGood	= XRT.TopPart
	DefaultPO		= default_po_number
,	PrimaryVendor	= default_vendor
-- ,LeadTime		= max(lead_time)
-- ,RealLeadTime	= max(real_lead_time)
,	BOM_Part		= XRT.ChildPart
,	BOM_Part_Description = part.name
,	Commodity		= part.commodity
,	Unique_Material	= Unique_Material
--  class			=,
-- ,PartClassification = (case
--							  when class = 'P' then
--								  'Purchased'
--							  when class = 'M' then
--								  'Manufactured'
--							  else
--								  'Other'
--						  end
--						 )
,   LeadTimeWeeks	= max(lead_time)/7 
,	StandardPack	= standard_pack
,	BOM_Qty			= sum(XRT.XQty)
,	BOM_UOM			= BOM.unit_measure
--,	ScrapFactor		= BOM.scrap_factor
,	Part_MaterialCum = avg(material_cum)
,	BOM_Ext_MaterialCum = avg(material_cum) * sum(XRT.XQty)
--,	SPI_MasterialAccum	= min(spsSPI.MaterialAccum)
--,	SPI_LaborAccum		= min(spsSPI.LaborAccum)
--,	SPI_BurdenAccum		= min(spsSPI.BurdenAccum)
--,	CN_MasterialAccum	= min(spsCN.MaterialAccum)
--,	CN_LaborAccum		= min(spsCN.LaborAccum)
--,	CN_BurdenAccum		= min(spsCN.BurdenAccum)
from
	FT.XRt XRT
	join part
		on XRT.ChildPart = part.part
	join part_online
		on part.part = part_online.part
	join part_inventory
		on part.part = part_inventory.part
	left join part_vendor
		on part_vendor.part = part.part
		and part_vendor.vendor = part_online.default_vendor

	left join 	(	select childpart, (case when count(toppart) > 1 then 'NO' else 'Yes' end) as Unique_Material  
					from FT.XRt xrt2
						join part 
							on xrt2.toppart = part.part
						left join (		select part_number, sum(quantity) as quantity 
										from	eeisql1.monitor.dbo.order_detail 
										group by part_number
								  ) b
							on xrt2.toppart = b.part_number
					 where part.type = 'F'
					 and quantity > 0
					 group by childpart
				) aa 
		on xrt.childpart = aa.childpart

	join part_standard
		on part.part = part_standard.part
	left join dbo.bill_of_material_ec BOM
		on XRT.BOMID = BOM.ID
	left join dbo.part_machine PM
		on XRT.ChildPart = PM.part
		   and PM.sequence = 1
	left join dbo.activity_router AR
		on XRT.ChildPart = AR.parent_part

	--left join dbo.PartStandard_SPI spsSPI
	--	on spsSPI.Part = XRT.TopPart
	--left join dbo.PartStandard_CN spsCN
	--	on spsCN.Part = XRT.TopPart

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
,	Unique_Material
,	part_inventory.standard_pack
,	BOM.unit_measure
,	BOM.scrap_factor
,	default_vendor
,   default_po_number
,	class
order by
	XRT.TopPart
,	leadtimeweeks desc
,   default_vendor

--select (case when count(Where_Used_FG) > 1 then 'NO' else 'Yes' end) as Unique_Material from 
--(
--select toppart as Where_Used_FG, quantity as FG_qty_on_customer_order, 100* quantity/(sum(quantity) over ()) as Percent_Useage_on_this_FG from FT.XRt xrt
--join part on xrt.toppart = part.part
--left join (select part_number, sum(quantity) as quantity from eeisql1.monitor.dbo.order_detail group by part_number) b
--on xrt.toppart = b.part_number
-- where childpart = '54240002'
-- and part.type = 'F'
-- and quantity > 0
-- --order by quantity desc
-- ) a

GO

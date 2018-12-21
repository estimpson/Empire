SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view  [FT].[Ftsp_BOMPerPart_Incremental]


-- select * from FT.Ftsp_BOMPerPart_incremental order by base_part, toppart 


-- There is a problem where an RD part is put into the router for a H level part; the view returns a duplicate row (one for the H level and one for the rework level)
-- The desired result is one row per top_part
-- In the case of NAL0480-AD00 it appears the router is built incorrectly; the H level and R level are both included; which is duplicating the BOM cost
-- I would think there should be either the H level or the RD level but not both in this router
-- In any case, I only want to compare the top part with the next level down so can we limit the query by finding the level of the top part and then looking for the part belonging to the next level down?
-- Example:  select toppart, count(toppart) from ft.ftsp_bomperpart_incremental  group by toppart having count(toppart)>=2








as

select	aa.base_part, 
		aa.TopPart, 
		bb.ChildPart, 
		aa.BulbedPrice, 
		bb.UnbulbedPrice, 
		isnull(aa.BulbedPrice,0)-isnull(bb.UnBulbedPrice,0) as 'IncrementalPrice', 
		isnull(aa.IncrementalMaterialCost,0)+isnull(bb.UnbulbedMaterialCost,0) as 'BulbedMaterialCost',
		bb.UnbulbedMaterialCost,
		aa.IncrementalMaterialCost  
		
		
from 
(	select  Base_part = a.Base_part,
			TopPart = a.TopPart,
			IncrementalMaterialCost = sum(a.ExtendedMaterialCum),
			BulbedPrice = avg(a.BulbedPrice)

	from	
			(	select	 Base_part = left(XRT.TopPart,7),
						 TopPart = XRt.TopPart,
						 PrimaryVendor = default_vendor,
						 ChildPart = XRt.ChildPart,
						 BOMDescription = part.name,
						 Commodity = part.commodity,
						 --class,
						 PartClassification = (CASE WHEN class = 'P' THEN 'Purchased' WHEN class = 'M' THEN 'Manufactured' ELSE 'Other' END)	,
						 Qty = sum(XRt.XQty),
						 UOM = BOM.unit_measure,
						 ScrapFactor = BOM.scrap_factor,
						 MaterialCum = avg(eei_ps.material_cum),
						 ExtendedMaterialCUM = avg(eei_ps.material_cum)*sum(XRt.XQty),
						 BulbedPrice = avg(eei_ps.price)
						 

				from	 FT.XRt XRT
					join part on XRt.ChildPart = part.part
					JOIN part_online on part.part = part_online.part
					JOIN part_standard eei_ps ON part.part = eei_ps.part
			   LEFT JOIN dbo.bill_of_material_ec BOM on XRt.BOMID = BOM.ID
			   LEFT JOIN dbo.part_machine PM on XRt.ChildPart = PM.part 
							and PM.sequence = 1
			   LEFT JOIN dbo.activity_router AR on XRt.ChildPart = AR.parent_part
		
				where	XRt.TopPart in (select part from dbo.part where type = 'F')
					and class <> 'M'
					and left(XRt.ChildPart,3) <> left(xrt.topPart,3)
					and default_vendor <> 'EEH'

				group by XRt.TopPart, XRt.ChildPart, part.name, part.commodity, BOM.unit_measure, BOM.scrap_factor, default_vendor, class
			) a 
	
	group by a.Base_Part, a.TopPart 
	--order by 1,2
)aa

join 

--(
--select base_part,
--	   Toppart,
--	   min(ChildPart) as childpart,
--	   sum(unbulbedprice) as unbulbedprice,
--	   sum(unbulbedmaterialcost) as unbulbedmaterialcost
--from 

(
select	Base_part = left(XRT.ChildPart,7),
		TopPart = XRt.TopPart,
		ChildPart = XRt.ChildPart,
		UnbulbedPrice = isnull(eei_ps.price,0),
		UnbulbedMaterialCost = isnull(eeh_ps.material_cum,0)
				
from	FT.XRt XRT
		 join	part on XRt.ChildPart = part.part
	LEFT JOIN	part_standard eei_ps ON XRT.ChildPart = eei_ps.part
	LEFT JOIN	eehsql1.monitor.dbo.part_standard eeh_ps on XRT.ChildPart = eeh_ps.part
	LEFT JOIN	part_machine PM on XRt.ChildPart = PM.part and PM.sequence = 1
		
where	left(XRt.ChildPart,3) = left(xrt.topPart,3)
	and class <> 'M'
	and XRT.ChildPart <> XRT.TopPart
	--and PM.sequence <> 1
	and XRt.TopPart in 
		(select part 
		from dbo.part 
		where type = 'F')
--)b

--group by 
--		base_part,
--		Toppart,
--		ChildPart

)bb 

on aa.TopPart = bb.TopPart





GO

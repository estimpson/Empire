SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [HN].[BOM_Query] as

select	
	Customer = left(Toppart,3),
	TopPart = xrt.TopPart, 
	TopPartType = Part_1.type, Part = xrt.ChildPart, 
	Description = Part.name,
	PartType = Part.type, Qty = Sum(xrt.XQty), 
	Material_Cum = Max(Part_standard.material_cum), ExtendCost = Sum(xQty*Part_standard.Material_Cum), 
	part_online.default_vendor,
	lead_time = part_vendor.lead_time,
	real_lead_time = part_vendor.real_lead_time,
	Part_inventory.standard_pack,
	TotalDemand = (select sum(qnty) from master_prod_sched where master_prod_sched.part = xrt.childpart ),
	VendorPrice = (select Avg(price)
	               from part_vendor_price_matrix 
	               where part_vendor_price_matrix.part = xrt.childpart 
	               and part_vendor_price_matrix.vendor = part_online.default_vendor),
	IsInProduction = (select 'Y' 
	                  from sistema.dbo.cp_revisiones_produccion cpr 
	                  where cpr.part = xrt.toppart 
				and contenedorID = (select contenedorID from sistema.dbo.cp_contenedores where activo = 1)),
	IsInfuture = (select 'Y' 
	                  from sistema.dbo.cp_contenedores_futuros cpf
	                  where cpf.part = xrt.toppart 
				and contenedorID = (select contenedorID from sistema.dbo.cp_contenedores where activo = 1))
from	FT.xrt xrt
	join Part_standard Part_standard on xrt.ChildPart = Part_standard.part  
	join Part Part on Part_standard.part = Part.part 
	join part_online part_online on Part.part = part_online.part 
	join part_inventory on part.part = part_inventory.part
	join part Part_1 on xrt.TopPart = Part_1.part
	left join part_vendor on xrt.ChildPart = part_vendor.part and part_vendor.vendor = part_online.default_vendor 
group by xrt.TopPart, Part_1.type, xrt.ChildPart, Part.name, Part.type, part_online.default_vendor, part_vendor.lead_time, Part_inventory.standard_pack, part_vendor.real_lead_time


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_compare_eei_eeh_cost_price]
as
select	eei_part=part_standard.part,
		eeh_part=vw_eeh_cost_price.part,
		eei_order_header_price=order_header.alternate_price,
		eei_standard_price=part_standard.price,
		eei_material_cost=part_standard.material,
		eei_material_cum=part_standard.material_cum,
		eeh_order_header_price=vw_eeh_cost_price.order_header_price,
		eeh_order_detail_price=vw_eeh_cost_price.order_header_price,
		eeh_pc_price=vw_eeh_cost_price.pc_price,
		eeh_pcpm_price=vw_eeh_cost_price.pcpm_price,
		eeh_standard_price=vw_eeh_cost_price.standard_price,
		eeh_material_cum=vw_eeh_cost_price.standard_material_cum
from	part_standard
full join	vw_eeh_cost_price on  part_standard.part = vw_eeh_cost_price.part
join		order_header on isnull (part_standard.part,vw_eeh_cost_price.part)  = order_header.blanket_part
GO

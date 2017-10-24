SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_cost_price]

as


Select * 
from


(select	 part=part_standard.part,
		 order_header_price=order_header.alternate_price,
		order_detail_price=(select max(alternate_price) from order_detail where order_detail.order_no = order_header.order_no),
		pcpm_price=(select max(alternate_price) from part_customer_price_matrix where part_customer_price_matrix.part = part_standard.part and part_customer_price_matrix.customer = order_header.customer),
		pc_price=(select max(blanket_price) from part_customer where part_customer.part = part_standard.part and part_customer.customer = order_header.customer),
		 standard_price= isNULL(part_standard.price,0),
		 standard_material_cum=isNULL(part_standard.material_cum,0),
		 standard_material=isNULL(part_standard.material,0)
from	part_standard
left outer join		order_header on part_standard.part = order_header.blanket_part
join		part on part_standard.part = part.part
where	part.type = 'F') EEIPriceCost
GO

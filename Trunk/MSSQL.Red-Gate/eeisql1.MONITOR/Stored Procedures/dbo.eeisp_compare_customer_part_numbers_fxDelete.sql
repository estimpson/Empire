SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_compare_customer_part_numbers_fxDelete]
as
Begin
Select	part_customer.customer,
		part.part,
		part.cross_ref,
		order_header.customer_part,
		part_customer.customer_part
from	part
left outer join order_header on part.part = order_header.blanket_part
left outer join	part_customer on part.part = part_customer.part
where	part.cross_ref <> order_header.blanket_part or
		part.cross_ref <> part_customer.customer_part or
		order_header.blanket_part <> part_customer.customer_part

end
		
		
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [EEIUser].[vw_eei_non_Scheduled_customer_orders]
as

Select	order_detail.order_no,
		order_detail.part_number,
		order_detail.customer_part,
		order_detail.quantity,
		order_detail.committed_qty,
		order_detail.due_date,
		destination.scheduler,
		order_detail.release_no		
		 
from		order_detail
join		order_header on order_detail.order_no = order_header.order_no
join		destination on order_header.destination = destination.destination 
where	order_detail.due_date <= dateadd(dd,6,getdate()) and 
		quantity > 1 and 
		committed_qty<quantity
GO

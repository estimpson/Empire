SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [FT].[usp_fixOrderDetail_MissingCustomerPart] (@shipperID int)
as
Begin
update order_detail 
set order_detail.customer_part = order_header.customer_part
From 
	order_detail 
join order_header on order_header.order_no = order_detail.order_no
where order_detail.customer_part is NULL and order_detail.order_no in ( Select order_no from shipper_detail where shipper = @shipperID  )
End
GO

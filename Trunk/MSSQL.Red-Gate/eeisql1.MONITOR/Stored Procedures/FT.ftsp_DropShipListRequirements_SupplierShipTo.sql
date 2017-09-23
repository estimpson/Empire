SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_DropShipListRequirements_SupplierShipTo]
	@SupplierCode varchar(10)
,	@ShipToCode varchar(20)
as /*
Example:
execute	FT.ftsp_DropShipListRequirements_SupplierShipTo
	@SupplierCode = 'HITE01',
	@ShipToCode = 'AUSM01'

:End Example
*/
set nocount on

select
	OrderDetailID = order_detail.id
,	Part = order_detail.part_number
,	OrderQty = order_detail.quantity
,	DueDate = order_detail.due_date
,	CustomerPO = order_header.customer_po
,	Selected = 0
from
	order_header
	join order_detail
		on order_header.order_no = order_detail.order_no
	join po_detail
		on order_detail.order_no = po_detail.sales_order
			and order_detail.row_id = po_detail.dropship_oe_row_id
where
	order_detail.ship_type = 'D'
	and po_detail.vendor_code = @SupplierCode
	and order_header.destination = @ShipToCode
order by
	2
,	4
GO

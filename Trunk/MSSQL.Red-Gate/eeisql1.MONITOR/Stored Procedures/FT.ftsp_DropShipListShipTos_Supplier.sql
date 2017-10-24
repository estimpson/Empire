SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[ftsp_DropShipListShipTos_Supplier]
	@SupplierCode varchar(10)
as /*
Example:
execute	FT.ftsp_DropShipListShipTos_Supplier
	@SupplierCode = 'HITE01'

:End Example
*/
set nocount on

select
	ShipToCode = destination.destination
,	ShipToName = destination.name
from
	order_header
	join destination
		on order_header.destination = destination.destination
	join order_detail
		on order_header.order_no = order_detail.order_no
	join po_detail
		on order_detail.order_no = po_detail.sales_order
			and order_detail.row_id = po_detail.dropship_oe_row_id
where
	order_detail.ship_type = 'D'
	and po_detail.vendor_code = @SupplierCode
group by
	destination.destination
,	destination.name
GO

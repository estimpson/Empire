SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_DropShipListSuppliers]
as /*
Example:
execute	FT.ftsp_DropShipListSuppliers

:End Example
*/
set nocount on

select
	SupplierCode = vendor.code
,	SupplierName = vendor.name
from
	order_header
	join order_detail
		on order_header.order_no = order_detail.order_no
	join po_detail
		on order_detail.order_no = po_detail.sales_order
			and order_detail.row_id = po_detail.dropship_oe_row_id
	join vendor
		on po_detail.vendor_code = vendor.code
where
	order_header.ship_type = 'D'
group by
	vendor.code
,	vendor.name
GO

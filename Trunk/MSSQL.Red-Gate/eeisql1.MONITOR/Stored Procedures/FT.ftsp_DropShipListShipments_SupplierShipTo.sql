SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_DropShipListShipments_SupplierShipTo]
	@SupplierCode varchar(10)
,	@ShipToCode varchar(20)
as /*
Example:
execute	FT.ftsp_DropShipListShipments_SupplierShipTo
	@SupplierCode = 'RDSC01',
	@ShipToCode = 'HITE01'

:End Example
*/
set nocount on

select
	shipper.id
,	min(shipper.date_shipped)
,	count(distinct shipper_detail.part)
,	min(shipper_detail.part)
,	max(shipper_detail.part)
from
	shipper
	join shipper_detail
		on shipper.id = shipper_detail.shipper
	join order_header
		on shipper_detail.order_no = order_header.order_no
	join order_detail
		on order_header.order_no = order_detail.order_no
	join po_detail
		on order_detail.order_no = po_detail.sales_order
			and order_detail.row_id = po_detail.dropship_oe_row_id
where
	shipper.invoice_printed = 'N'
	and order_header.ship_type = 'D'
	and po_detail.vendor_code = @SupplierCode
	and order_header.destination = @ShipToCode
group by
	shipper.id
order by
	1
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [FT].[ftsp_DropShipRefreshPODetail1]
(	@Result integer = 0 output
--<Debug>
	, @Debug integer = 0
--</Debug>
)
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int

execute	@ProcReturn = FT.ftsp_DropShipRefreshPODetail
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult

select	getdate (),*
from	po_detail

rollback
:End Example
*/
as
set	nocount on
set	@Result = 999999

--	I.	Refresh purchase order detail for drop ship orders.
delete
	po_detail
where
	ship_type = 'D'

--	II.	Create purchase order detail for drop ship orders.
insert
	po_detail
(	po_number, vendor_code, part_number, description, unit_of_measure, date_due, status, type, cross_reference_part, 
	quantity, received, balance, price, row_id, ship_to_destination, terms, week_no, plant, standard_qty, sales_order,
	dropship_oe_row_id, ship_type, price_unit, printed, selected_for_print, deleted, ship_via, alternate_price)
select	po_number = po_header.po_number,
	vendor_code = po_header.vendor_code,
	part_number = po_header.blanket_part,
	description = part.name,
	unit_of_measure = part_vendor.receiving_um,
	date_due = order_detail.due_date,
	status = 'A',
	type = 'B',
	cross_reference_part = convert (varchar (25), part.cross_ref),
	quantity = order_detail.quantity,
	received = 0,
	balance = order_detail.quantity,
	price =
	(	select	min (price)
		from	part_vendor_price_matrix
		where	po_header.blanket_part = part_vendor_price_matrix.part and
			po_header.vendor_code = part_vendor_price_matrix.vendor and
			part_vendor_price_matrix.break_qty <= order_detail.quantity),
	row_id =
	(	select	count (1) + 1
		from	order_detail od
		where	part_number = order_detail.part_number and
			(	due_date < order_detail.due_date or
				(	due_date = order_detail.due_date and
					id < order_detail.id))),
	ship_to_destination = order_header.destination,
	terms = po_header.terms,
	week_no = datepart (wk, order_detail.due_date),
	plant = 'EEC',
	standard_qty = order_detail.quantity,
	sales_order = order_detail.order_no,
	dropship_oe_row_id = order_detail.row_id,
	ship_type = 'D',
	price_unit = 'P',
	printed = 'N',
	selected_for_print = 'N',
	deleted = 'N',
	ship_via = destination_shipping.scac_code,
	alternate_price =
	(
		select
			min (price)
		from
			part_vendor_price_matrix
		where
			po_header.blanket_part = part_vendor_price_matrix.part and
			po_header.vendor_code = part_vendor_price_matrix.vendor and
			part_vendor_price_matrix.break_qty <= order_detail.quantity)
from
	order_header
	join order_detail on order_header.order_no = order_detail.order_no
	join destination_shipping on order_header.destination = destination_shipping.destination
	join dbo.part_online po on
		po.part = order_detail.part_number
	join po_header on
		po_header.po_number = coalesce(order_detail.dropship_po, po.default_po_number, (select max(po_number) from po_header where blanket_part = order_detail.part_number))
	join part on po_header.blanket_part = part.part
	join part_vendor on po_header.blanket_part = part_vendor.part and
		po_header.vendor_code = part_vendor.vendor
where
	order_detail.ship_type = 'D' and
	order_header.cs_status = 'Approved' and
	isnull (order_detail.status, 'O') != 'H'

--	III.	Set the links from sales order detail to purchase order detail.
update
	order_detail
set	dropship_po = po_detail.po_number,
	dropship_po_row_id = po_detail.row_id
from
	order_detail
	join po_detail on order_detail.order_no = po_detail.sales_order and
		order_detail.row_id = po_detail.dropship_oe_row_id

--	IV.	Refreshed.
set	@Result = 0
return	@Result
GO

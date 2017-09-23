SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [FT].[ftsp_DropShipProcessShipment]
	@SalesOrderDetailID int
,	@ShipperID int = null output
,	@ShipQty numeric(20,6)
,	@ShipDate datetime
,	@SupplierShipper varchar(10)
,	@PRONumber varchar(35)
,	@UserCode varchar(5)
,	@UserPassword varchar(5)
,	@VendorCode varchar(15)
,	@Result integer = 0 output
--<Debug>
,	@Debug integer = 0
--</Debug>
as /*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@ShipperID int

execute	@ProcReturn = FT.ftsp_DropShipProcessShipment
	@SalesOrderDetailID = 25,
	@ShipperID = @ShipperID output,
	@ShipQty = 5950,
	@ShipDate = '2007-03-28',
	@SupplierShipper = '123456890',
	@UserCode = 'mon',
	@UserPassword = 'mon',
	@VendorCode=
	@Result = @ProcResult output

select	[@ProcReturn] = @ProcReturn,
	[@ProcResult] = @ProcResult,
	[@ShipperID] = @ShipperID

select	*
from	order_detail
where	id = 25

select	*
from	shipper_detail
where	shipper = @ShipperID

select	*
from	audit_trail
where	dropship_shipper = @ShipperID
rollback
:End Example
*/
set	nocount on
set @Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
declare @TranCount smallint
set @TranCount = @@TranCount
if @TranCount = 0 
	begin
		begin transaction StagingAddInvToShipper
	end
save transaction StagingAddInvToShipper
--</Tran>

--<Error Handling>
declare
	@ProcReturn integer
,	@ProcResult integer
,	@Error integer
,	@RowCount integer
--</Error Handling>

--	II.	Get a serial.
--<Debug>
if @Debug & 1 = 1 
	begin
		print 'II.	Get a serial.'
	end
--</Debug>
declare @Serial int
select
	@Serial = next_serial
from
	parameters with (tablockx)

while
	exists
	(	select
			serial
		from
			object
		where
			serial = @Serial
	)
	or exists
	(	select
			serial
		from
			audit_trail
		where
			serial = @Serial
	) begin

	set @Serial = @Serial + 1
end

update
	parameters
set 
	next_serial = @Serial + 1

if	@ShipperID is null begin
--	II.	Get a shipper.
--<Debug>
	if @Debug & 1 = 1 
		begin
			print 'II.	Get a shipper.'
		end
--</Debug>
	select
		@ShipperID = shipper
	from
		parameters with (tablockx)

	while
		exists
		(	select
				id
			from
				shipper
			where
				id = @ShipperID
		)
		or exists
		(	select
				shipper
			from
				shipper_detail
			where
				shipper = @ShipperID
		) begin

		set @ShipperID = @ShipperID + 1
	end

	update
		parameters
	set 
		shipper = @ShipperID + 1
	
	insert
		shipper
	(	id
	,	destination
	,	ship_via
	,	status
	,	date_shipped
	,	freight_type
	,	customer
	,	plant
	,	type
	,	invoiced
	,	invoice_number
	,	freight
	,	pro_number
	,	invoice_printed
	,	terms
	,	tax_rate
	,	dropship_reconciled
	,	date_stamp
	,	cs_status
	)
	select
		id = @Shipperid
	,	destination = order_header.destination
	,	ship_via = destination_shipping.scac_code
	,	status = 'C'
	,	date_shipped = @ShipDate
	,	freight_type = destination_shipping.freigt_type
	,	customer = destination.customer
	,	plant = order_header.plant
	,	type = 'D'
	,	invoiced = 'N'
	,	invoice_number = @ShipperID
	,	freight = 0
	,	pro_number = @PRONumber
	,	invoice_printed = 'N'
	,	terms = order_header.term
	,	tax_rate = 0
	,	dropship_reconciled = 'Y'
	,	date_stamp = @ShipDate
	,	cs_status = customer.cs_status
	from
		order_detail
		join order_header
			on order_detail.order_no = order_header.order_no
		join customer
			on order_header.customer = customer.customer
		join destination
			on order_header.destination = destination.destination
		join destination_shipping
			on order_header.destination = destination_shipping.destination
	where
		order_detail.id = @SalesOrderDetailID
end

insert
	shipper_detail
(	shipper
,	part
,	suffix
,	qty_required
,	qty_packed
,	qty_original
,	accum_shipped
,	order_no
,	customer_po
,	release_no
,	release_date
,	price
,	date_shipped
,	operator
,	alternative_qty
,	alternative_unit
,	price_type
,	customer_part
,	dropship_po
,	dropship_po_row_id
,	dropship_oe_row_id
,	part_name
,	part_original
,	total_cost
,	dropship_po_serial
,	dropship_invoice_serial
,	alternate_price
)
select
	shipper = @ShipperID
,	part = order_detail.part_number +
		case SDSuffix.Suffix
			when 0 then ''
			else '-' + convert (varchar,SDSuffix.Suffix)
		end
,	suffix =
		case SDSuffix.Suffix
			when 0 then null
			else SDSuffix.Suffix
		end
,	qty_required = @ShipQty
,	qty_packed = @ShipQty
,	qty_original = order_detail.quantity
,	accum_shipped = isnull(order_header.our_cum,0) + @ShipQty
,	order_no = order_detail.order_no
,	customer_po = order_header.customer_po
,	release_no = order_detail.release_no
,	release_date = order_detail.due_date
,	price = order_detail.price
,	date_shipped = @ShipDate
,	operator = @UserCode
,	alternative_qty = @ShipQty
,	alternative_unit = order_detail.unit
,	price_type = order_header.price_unit
,	customer_part = order_header.customer_part
,	dropship_po = po_detail.po_number
,	dropship_po_row_id = po_detail.row_id
,	dropship_oe_row_id = order_detail.row_id
,	part_name = part.name
,	part_original = order_detail.part_number
,	total_cost = @ShipQty * order_detail.price
,	dropship_po_serial = @Serial
,	dropship_invoice_serial = @Serial
,	alternate_price = order_detail.alternate_price
from
	order_detail
	join order_header
		on order_detail.order_no = order_header.order_no
	join po_detail
		on order_detail.order_no = po_detail.sales_order
			and order_detail.row_id = po_detail.dropship_oe_row_id
			and po_detail.vendor_code = @VendorCode
	join part
		on order_detail.part_number = part.part
	cross join
	(	select
			Suffix = count(1)
		from
			shipper_detail
		where
			shipper_detail.shipper = @ShipperID
			and part_original =
			(	select
					part_number
				from
					order_detail
				where
					id = @SalesOrderDetailID
			)
	) SDSuffix
where
	order_detail.id = @SalesOrderDetailID

update
	order_header
set 
	our_cum = isnull(order_header.our_cum,0) + @ShipQty
from
	order_header
	join order_detail
		on order_header.order_no = order_detail.order_no
where
	order_detail.id = @SalesOrderDetailID

update
	order_detail
set 
	quantity = quantity - @ShipQty
,	std_qty = std_qty - @ShipQty
,	our_cum = our_cum + @ShipQty
where
	id = @SalesOrderDetailID

update
	po_detail
set 
	last_recvd_date = @ShipDate
,	last_recvd_amount = @ShipQty
,	received = po_detail.received + @ShipQty
,	balance = po_detail.balance + @ShipQty
from
	po_detail
	join order_detail
		on po_detail.sales_order = order_detail.order_no
			and po_detail.dropship_oe_row_id = order_detail.row_id
			and po_detail.vendor_code = @VendorCode
where
	order_detail.id = @SalesOrderDetailID

update
	part_vendor
set 
	accum_shipped = part_vendor.accum_shipped + @ShipQty
,	accum_received = part_vendor.accum_received + @ShipQty
from
	part_vendor
	join po_detail
		on part_vendor.part = po_detail.part_number
			and part_vendor.vendor = po_detail.vendor_code
	join order_detail
		on po_detail.sales_order = order_detail.order_no
			and po_detail.dropship_oe_row_id = order_detail.row_id
where
	order_detail.id = @SalesOrderDetailID
	and part_vendor.vendor = @VendorCode

insert
	audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	price
,	salesman
,	customer
,	vendor
,	po_number
,	operator
,	from_loc
,	to_loc
,	on_hand
,	status
,	shipper
,	unit
,	std_quantity
,	cost
,	plant
,	invoice_number
,	sales_order
,	release_no
,	dropship_shipper
,	std_cost
,	user_defined_status
,	destination
,	show_on_shipper
)
select
	serial = @Serial
,	date_stamp = @ShipDate
,	type = 'R'
,	part = order_detail.part_number
,	quantity = @ShipQty
,	remarks = 'Receiving'
,	price = po_detail.price
,	salesman = order_header.salesman
,	customer = order_header.customer
,	vendor = po_detail.vendor_code
,	po_number = po_detail.po_number
,	operator = @UserCode
,	from_loc = po_detail.vendor_code
,	to_loc = order_header.destination
,	on_hand = @ShipQty
,	status = 'A'
,	shipper = @SupplierShipper
,	unit = po_detail.unit_of_measure
,	std_quantity = @ShipQty
,	cost = part_standard.cost_cum
,	plant = order_header.plant
,	invoice_number = null
,	sales_order = null
,	release_no = po_detail.release_no
,	dropship_shipper = @ShipperID
,	std_cost = part_standard.cost_cum
,	user_defined_status = 'Approved'
,	destination = order_header.destination
,	show_on_shipper = null
from
	order_detail
	join order_header
		on order_detail.order_no = order_header.order_no
	join po_detail
		on order_detail.order_no = po_detail.sales_order
			and order_detail.row_id = po_detail.dropship_oe_row_id
			and po_detail.vendor_code = @VendorCode
	join part_standard
		on order_detail.part_number = part_standard.part
where
	order_detail.id = @SalesOrderDetailID

insert
	audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	price
,	salesman
,	customer
,	vendor
,	po_number
,	operator
,	from_loc
,	to_loc
,	on_hand
,	status
,	shipper
,	unit
,	std_quantity
,	cost
,	plant
,	invoice_number
,	sales_order
,	release_no
,	dropship_shipper
,	std_cost
,	user_defined_status
,	destination
,	show_on_shipper
)
select
	serial = @Serial
,	date_stamp = @ShipDate
,	type = 'S'
,	part = order_detail.part_number
,	quantity = @ShipQty
,	remarks = 'Shipping'
,	price = order_detail.price
,	salesman = order_header.salesman
,	customer = order_header.customer
,	vendor = po_detail.vendor_code
,	po_number = po_detail.po_number
,	operator = @UserCode
,	from_loc = po_detail.vendor_code
,	to_loc = order_header.destination
,	on_hand = @ShipQty
,	status = 'A'
,	shipper = @ShipperID
,	unit = order_detail.unit
,	std_quantity = @ShipQty
,	cost = part_standard.cost_cum
,	plant = order_header.plant
,	invoice_number = @ShipperID
,	sales_order = order_detail.order_no
,	release_no = order_detail.release_no
,	dropship_shipper = @ShipperID
,	std_cost = part_standard.cost_cum
,	user_defined_status = 'Approved'
,	destination = order_header.destination
,	show_on_shipper = 'Y'
from
	order_detail
	join order_header
		on order_detail.order_no = order_header.order_no
	join po_detail
		on order_detail.order_no = po_detail.sales_order
			and order_detail.row_id = po_detail.dropship_oe_row_id
			and po_detail.vendor_code = @VendorCode
	join part_standard
		on order_detail.part_number = part_standard.part
where
	order_detail.id = @SalesOrderDetailID

delete
	po_detail
from
	po_detail
	join order_detail
		on po_detail.sales_order = order_detail.order_no
			and po_detail.dropship_oe_row_id = order_detail.row_id
where
	order_detail.id = @SalesOrderDetailID
	and order_detail.quantity <= 0
	and po_detail.vendor_code = @VendorCode

delete
	order_detail
where
	id = @SalesOrderDetailID
	and quantity <= 0
GO

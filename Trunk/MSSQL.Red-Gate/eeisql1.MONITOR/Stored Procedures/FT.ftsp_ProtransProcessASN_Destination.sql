SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[ftsp_ProtransProcessASN_Destination]
(	@Operator varchar (5),
	@ProTransOrderNo int,
	@CustomerDestination varchar (20),
	@InvoiceShipperID int output,
	@Result int = 0 output)
/*
Example:
begin transaction
select	OrderNo,
	CustomerPart,
	InvPart,
	ShipDate,
	ShipTime,
	sum (convert (numeric (20,6), Quantity)),
	sum (convert (numeric (20,6), InvQuantity)),
	CountQtyMismatch = sum (case when convert (numeric (20,6), Quantity) != convert (numeric (20,6), InvQuantity) then 1 else 0 end),
	CountMissingInv = sum (case when InvQuantity is null then 1 else 0 end),
	CountProcessed = (select min (status) from shipper where shipper.pro_number = vwProTransASNUnprocessed.OrderNo)
from	FT.vwProTransASNUnprocessed vwProTransASNUnprocessed
where	IsNumeric (Quantity) = 1 and
	IsNumeric (InvQuantity) = 1
group by
	OrderNo,
	CustomerPart,
	InvPart,
	ShipDate,
	ShipTime
order by
	1, 3

declare	@ProcReturn int,
	@ProcResult int,
	@InvoiceShipperID int

execute	@ProcReturn = FT.ftsp_ProtransProcessASN
	@Operator = 'MON',
	@ProTransOrderNo = 457569,
	@CustomerDestination = 'ALC',
	@InvoiceShipperID = @InvoiceShipperID output,
	@Result = @ProcResult output

select	@InvoiceShipperID,
	@ProcReturn,
	@ProcResult

select	*
from	shipper
where	id = @InvoiceShipperID

select	*
from	shipper_detail
where	shipper = @InvoiceShipperID

commit
:End Example
*/
as

set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction ProtransProcessASN
end
save transaction ProtransProcessASN
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,	@RowCount integer
--</Error Handling>

--	Argument Validation:
--		Operator required:
if	not exists
	(	select	1
		from	employee
		where	operator_code = @Operator) begin

	set	@Result = 60001
	rollback tran StagingAddInvToShipper
	RAISERROR (@Result, 16, 1, @Operator)
	--return	@Result
end

select	@InvoiceShipperID = shipper
from	parameters with (TABLOCKX)

while	Exists (
	(	select	1
		from	shipper
		where	id = @InvoiceShipperID)) begin
	set	@InvoiceShipperID = @InvoiceShipperID + 1
end

update	parameters
set	shipper = @InvoiceShipperID + 1

declare	@Inventory table
(	ShipDT datetime)

insert	@Inventory
select	ShipDT = min (convert (datetime, '20' + right (rtrim (ShipDate), 2) + '-' + left (ShipDate, 2) + '-' + Substring (ShipDate, 3, 2) + ' ' + left (ShipTime, 2) + ':' + right (ShipTime, 2)))
from	FT.vwProTransASNUnprocessed vwProTransASNUnprocessed
	join order_header on order_header.order_no =
		(	select	max (order_no)
			from	order_header
			where	vwProTransASNUnprocessed.InvPart = order_header.blanket_part and
				order_header.destination = @CustomerDestination)
	join object on order_header.blanket_part = object.part and
		(	vwProTransASNUnprocessed.InvSerial = object.serial or
			vwProTransASNUnprocessed.InvSerial = object.parent_serial)
where	vwProTransASNUnprocessed.OrderNo = @ProTransOrderNo

insert	shipper
(	id, destination, ship_via, status, aetc_number, freight_type, customer, location,
	staged_objs, plant, type, invoiced, freight, gross_weight, net_weight, tare_weight, trans_mode,
	invoice_printed, staged_pallets, picklist_printed, date_stamp, scheduled_ship_time, currency_unit, cs_status)
select	id = @InvoiceShipperID, destination = @CustomerDestination, ship_via = 'CUST', status = 'O', aetc_number = convert (varchar, @ProTransOrderNo), freight_type = 'Prepaid', customer =
	(	select	customer
		from	destination
		where	destination = @CustomerDestination),
	location = 'SHIP POINT', staged_objs = 0,
	plant = 'EEI', type = null, invoiced = 'N', freight = 0, gross_weight = 0, net_weight = 0, tare_weight = 0, trans_mode = 'LT',
	invoice_printed = 'N', staged_pallets = 0,
	picklist_printed = 'N', date_stamp = Inventory.ShipDT, scheduled_ship_time = Inventory.ShipDT,
	currency_unit = 'USD', cs_status = 'Approved'
from	@Inventory Inventory

set	@Error = @@Error
set	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 9999999
	rollback tran ProtransProcessASN
	RAISERROR (@Result, 16, 1, 'ProtransProcessASN')
	return	@Result
end
if	@RowCount != 1 begin
	set	@Result = 9999999
	rollback tran ProtransProcessASN
	RAISERROR (@Result, 16, 1, 'ProtransProcessASN')
	return	@Result
end

insert	shipper_detail
(	shipper, part, qty_required, qty_packed, qty_original, order_no, customer_po, release_date,
	account_code,
	tare_weight, gross_weight, net_weight, boxes_staged, alternative_qty, alternative_unit,
	customer_part, part_name, part_original, stage_using_weight, price, alternate_price)
select	shipper = @InvoiceShipperID,
	part = vwProTransASNUnprocessed.InvPart,
	qty_required = sum (object.quantity), qty_packed = 0, qty_original = sum (object.quantity),
	order_no = min (order_header.order_no), customer_po = min (order_header.customer_po), release_date = min (convert (datetime, '20' + right (rtrim (ShipDate), 2) + '-' + left (ShipDate, 2) + '-' + Substring (ShipDate, 3, 2) + ' ' + left (ShipTime, 2) + ':' + right (ShipTime, 2))),
	account_code = min (part.gl_account_code),
	tare_weight = 0, gross_weight = 0, net_weight = 0, boxes_staged = 0, alternative_qty = 0, alternative_unit = 'EA',
	customer_part = min (order_header.customer_part), part_name = min (part.name), part_original = vwProTransASNUnprocessed.InvPart, stage_using_weight = 'N',
	min (order_header.price), min (order_header.alternate_price)
from	(	select	InvPart,
			InvSerial,
			ShipDate,
			ShipTime
		from	FT.vwProTransASNUnprocessed
		where	OrderNo = @ProTransOrderNo
		group by
			InvPart,
			InvSerial,
			ShipDate,
			ShipTime) vwProTransASNUnprocessed
	join order_header on order_header.order_no =
		(	select	max (order_no)
			from	order_header
			where	vwProTransASNUnprocessed.InvPart = order_header.blanket_part and
				order_header.destination = @CustomerDestination)
	join object on order_header.blanket_part = object.part and
		(	vwProTransASNUnprocessed.InvSerial = object.serial or
			vwProTransASNUnprocessed.InvSerial = object.parent_serial)
	join part on vwProTransASNUnprocessed.InvPart = part.part
group by
	vwProTransASNUnprocessed.InvPart

set	@Error = @@Error
set	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 9999999
	rollback tran ProtransProcessASN
	RAISERROR (@Result, 16, 1, 'ProtransProcessASN')
	return	@Result
end
if	@RowCount !> 0 begin
	set	@Result = 9999999
	rollback tran ProtransProcessASN
	RAISERROR (@Result, 16, 1, 'ProtransProcessASN')
	return	@Result
end

--	Stage loose boxes and pallets.
alter table object disable trigger all

update	object
set	shipper = @InvoiceShipperID,
	show_on_shipper = 'Y'
from	FT.vwProTransASNUnprocessed vwProTransASNUnprocessed
	join object on object.serial = vwProTransASNUnprocessed.InvSerial
where	vwProTransASNUnprocessed.OrderNo = @ProTransOrderNo

set	@Error = @@Error
set	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 9999999
	rollback tran ProtransProcessASN
	alter table object enable trigger all
	RAISERROR (@Result, 16, 1, 'ProtransProcessASN')
	return	@Result
end
if	@RowCount !> 0 begin
	set	@Result = 9999999
	rollback tran ProtransProcessASN
	alter table object enable trigger all
	RAISERROR (@Result, 16, 1, 'ProtransProcessASN')
	return	@Result
end

--	Stage objects on pallets.
update	object
set	shipper = @InvoiceShipperID,
	show_on_shipper = 'N'
from	FT.vwProTransASNUnprocessed vwProTransASNUnprocessed
	join object on object.parent_serial = vwProTransASNUnprocessed.InvSerial
where	vwProTransASNUnprocessed.OrderNo = @ProTransOrderNo

set	@Error = @@Error
set	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 9999999
	rollback tran ProtransProcessASN
	alter table object enable trigger all
	RAISERROR (@Result, 16, 1, 'ProtransProcessASN')
	return	@Result
end
if	@RowCount !> 0 begin
	set	@Result = 9999999
	rollback tran ProtransProcessASN
	alter table object enable trigger all
	RAISERROR (@Result, 16, 1, 'ProtransProcessASN')
	return	@Result
end

alter table object enable trigger all

--	Mark processed.
update	FT.ProTransASN
set	Status = 1
where	Status is null and
	OrderNo = @ProTransOrderNo

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction ProtransProcessASN
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
set	@Result = 0
return	@Result
GO

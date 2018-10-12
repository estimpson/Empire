SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ProdControl_BackFlush]
(	@Operator varchar (10),
	@BFID varchar (25),
	@Result int out)
as
/*
begin transaction
declare	@ProcResult int,
	@ProcReturn int,
	@Operator varchar (10),
	@WODID int,
	@QtyRequested numeric (20,6),
	@Override int,
	@NewSerial int

set	@Operator = 'Mon'
set	@WODID = 4
set	@QtyRequested = 180
set	@Override = 1

--		A.	Get a serial number.
select	@NewSerial = next_serial
from	parameters with (TABLOCKX)

while	exists
	(	select	serial
		from	object
		where	serial = @NewSerial) or
	exists
	(	select	serial
		from	audit_trail
		where	serial = @NewSerial) begin

	set	@NewSerial = @NewSerial + 1
end

update	parameters
set	next_serial = @NewSerial + 1

declare	@NewBFID int

--		A.	Create back flush header.
insert	BackFlushHeaders
(	WODID,
	PartProduced,
	SerialProduced,
	QtyProduced)
select	ID,
	Part,
	@NewSerial,
	@QtyRequested
from	WODetails
where	ID = @WODID

set	@NewBFID = SCOPE_IDENTITY ()

--		B.	Execute back flush details.
execute	@ProcReturn = FT.ftsp_ProdControl_BackFlush
	@Operator = @Operator,
	@BFID = @NewBFID,
	@Result = @ProcResult

select	@ProcResult,
	@NewSerial,
	@ProcReturn

select	*
from	BackFlushHeaders

select	*
from	BackFlushDetails

select	*
from	audit_trail
where	date_stamp >= DateAdd (n, -1, getdate()) and
	serial in
	(	select	SerialConsumed
		from	BackFlushDetails)

select	*
from	object
where	serial in
	(	select	SerialConsumed
		from	BackFlushDetails)

rollback

*/
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction BackFlush
end
else	begin
	save transaction BackFlush
end
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer
--</Error Handling>

--	I.	Calculate quantity to issue.
declare	@WOID int,
	@WODID int,
	@PartProdueced varchar (25),
	@QtyRequested numeric (20,6),
	@Machine varchar (10),
	@Shift char (1)

select	@WOID = WOHeaders.ID,
	@WODID = WODetails.ID,
	@PartProdueced = BackFlushHeaders.PartProduced,
	@QtyRequested = BackFlushHeaders.QtyProduced,
	@Machine = WOHeaders.Machine,
	@Shift = WOShift.Shift
from	BackFlushHeaders
	join WODetails on BackFlushHeaders.WODID = WODetails.ID
	join WOHeaders on WODetails.WOID = WOHeaders.ID
	join WOShift on WODetails.WOID = WOShift.WOID
where	BackFlushHeaders.ID = @BFID

declare @Inventory table
(	Serial int,
	Part varchar (25),
	BOMLevel tinyint,
	Sequence tinyint,
	Suffix tinyint,
	BOMID int,
	AllocationDT datetime,
	QtyPer float,
	QtyAvailable float,
	QtyRequired float,
	QtyIssue float,
	QtyOverage float)

insert	@Inventory
select	*
from	FT.fn_GetBackflushDetailsX (@WODID, @QtyRequested)

select	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end
if	@RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end

--	II.	Write negative scrap for overage quantity.
declare	@TranDT datetime
set	@TranDT = GetDate ()

insert	object
(	serial, part, location, last_date, quantity, po_number, operator,
	lot, weight, status, shipper, unit_measure, workorder,
	std_quantity, cost, custom1, custom2, custom3, custom4, custom5, plant,
	package_type, suffix, date_due, std_cost, user_defined_status,
	engineering_level, parent_serial, origin, destination, sequence, type,
	name, start_date, field1, field2, show_on_shipper, tare_weight,
	kanban_number, dimension_qty_string, dim_qty_string_other, varying_dimension_code)
select	serial = LastTrans.serial, part = LastTrans.part, location = 'Qty Disc',
	last_date = @TranDT, quantity = -Inventory.QtyOverage,
	po_number = LastTrans.po_number, operator = @Operator,
	lot = LastTrans.lot, weight = LastTrans.weight, status = 'S', shipper = LastTrans.shipper, unit = LastTrans.unit,
	workorder = convert (varchar, @WOID),
	std_quantity = -Inventory.QtyOverage, cost = LastTrans.cost, custom1 = LastTrans.custom1, custom2 = LastTrans.custom2,
	custom3 = LastTrans.custom3, custom4 = LastTrans.custom4, custom5 = LastTrans.custom5, plant = LastTrans.plant,
	package_type = LastTrans.package_type, suffix = LastTrans.suffix,
	date_due = LastTrans.due_date, std_cost = LastTrans.std_cost, user_defined_status = 'Scrap',
	engineering_level = LastTrans.engineering_level, parent_serial = LastTrans.parent_serial, origin = LastTrans.origin,
	destination = LastTrans.destination, sequence = LastTrans.sequence, type = LastTrans.object_type,
	name = LastTrans.part_name, start_date = LastTrans.start_date, field1 = LastTrans.field1, field2 = LastTrans.field2,
	show_on_shipper = LastTrans.show_on_shipper, tare_weight = LastTrans.tare_weight,
	kanban_number = LastTrans.kanban_number, dimension_qty_string = LastTrans.dimension_qty_string,
	dim_qty_string_other = LastTrans.dim_qty_string_other, varying_dimension_code = LastTrans.varying_dimension_code
from	(	select	Part,
			Serial,
			QtyOverage = sum (QtyOverage)
		from	@Inventory
		group by
			Part,
			Serial) Inventory
	join audit_trail LastTrans on Inventory.Serial = LastTrans.serial and
		LastTrans.date_stamp =
		(	select	max (date_stamp)
			from	audit_trail
			where	serial = Inventory.Serial)
	join part_online on Inventory.part = part_online.part
	join WODetails on WODetails.ID = @WODID
where	Inventory.QtyOverage > 0 and
	not exists
	(	select	1
		from	object
		where	Inventory.Serial = object.serial)

select	@Error = @@Error

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end

--	III.	Write material issue.
insert	audit_trail
(	serial, date_stamp, type, part, quantity, remarks, po_number, operator,
	from_loc, to_loc, on_hand, lot, weight, status, shipper, unit, workorder,
	std_quantity, cost, custom1, custom2, custom3, custom4, custom5, plant,
	notes, package_type, suffix, due_date, std_cost, user_defined_status,
	engineering_level, parent_serial, origin, destination, sequence, object_type,
	part_name, start_date, field1, field2, show_on_shipper, tare_weight,
	kanban_number, dimension_qty_string, dim_qty_string_other, varying_dimension_code)
select	serial = object.serial, date_stamp = @TranDT, type = 'D', part = object.part, quantity = -Inventory.QtyOverage,
	remarks = 'Qty Discr', po_number = object.po_number, operator = @Operator,
	from_loc = object.user_defined_status, to_loc = 'Scrap', on_hand = part_online.on_hand, lot = object.lot,
	weight = object.weight, status = 'S', shipper = object.shipper, unit = object.unit_measure, workorder = convert (varchar, @WOID),
	std_quantity = -Inventory.QtyOverage, cost = object.cost, custom1 = object.custom1, custom2 = object.custom2,
	custom3 = object.custom3, custom4 = object.custom4, custom5 = object.custom5, plant = object.plant,
	notes = 'Quantity discrepancy during backflush', package_type = object.package_type, suffix = object.suffix,
	due_date = object.date_due, std_cost = object.std_cost, user_defined_status = 'Scrap',
	engineering_level = object.engineering_level, parent_serial = object.parent_serial, origin = object.origin,
	destination = object.destination, sequence = object.sequence, object_type = object.type,
	part_name = object.name, start_date = object.start_date, field1 = object.field1, field2 = object.field2,
	show_on_shipper = object.show_on_shipper, tare_weight = object.tare_weight,
	kanban_number = object.kanban_number, dimension_qty_string = object.dimension_qty_string,
	dim_qty_string_other = object.dim_qty_string_other, varying_dimension_code = object.varying_dimension_code
from	(	select	Part,
			Serial,
			QtyOverage = sum (QtyOverage)
		from	@Inventory
		group by
			Part,
			Serial) Inventory
	join object on Inventory.Serial = object.serial
	join part_online on Inventory.part = part_online.part
where	Inventory.QtyOverage > 0

select	@Error = @@Error

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end

insert	audit_trail
(	serial, date_stamp, type, part, quantity, remarks, po_number, operator,
	from_loc, to_loc, on_hand, lot, weight, status, shipper, unit, workorder,
	std_quantity, cost, custom1, custom2, custom3, custom4, custom5, plant,
	notes, package_type, suffix, due_date, std_cost, user_defined_status,
	engineering_level, parent_serial, origin, destination, sequence, object_type,
	part_name, start_date, field1, field2, show_on_shipper, tare_weight,
	kanban_number, dimension_qty_string, dim_qty_string_other, varying_dimension_code)
select	serial = object.serial, date_stamp = dateadd (s, 1, @TranDT), type = 'M', part = object.part, quantity = Inventory.QtyIssue + Inventory.QtyOverage,
	remarks = 'Mat Issue', po_number = object.po_number, operator = @Operator,
	from_loc = object.location, to_loc = @Machine, on_hand = part_online.on_hand - (Inventory.QtyIssue + Inventory.QtyOverage), lot = object.lot,
	weight = object.weight, status = object.status, shipper = object.shipper, unit = object.unit_measure, workorder = convert (varchar, @WOID),
	std_quantity = Inventory.QtyIssue + Inventory.QtyOverage, cost = object.cost, custom1 = object.custom1, custom2 = object.custom2,
	custom3 = object.custom3, custom4 = object.custom4, custom5 = object.custom5, plant = object.plant,
	notes = '', package_type = object.package_type, suffix = object.suffix,
	due_date = object.date_due, std_cost = object.std_cost, user_defined_status = object.user_defined_status,
	engineering_level = object.engineering_level, parent_serial = object.parent_serial, origin = object.origin,
	destination = object.destination, sequence = object.sequence, object_type = object.type,
	part_name = object.name, start_date = object.start_date, field1 = object.field1, field2 = object.field2,
	show_on_shipper = object.show_on_shipper, tare_weight = object.tare_weight,
	kanban_number = object.kanban_number, dimension_qty_string = object.dimension_qty_string,
	dim_qty_string_other = object.dim_qty_string_other, varying_dimension_code = object.varying_dimension_code
from	(	select	Part,
			Serial,
			QtyIssue = sum (QtyIssue),
			QtyOverage = sum (QtyOverage)
		from	@Inventory
		group by
			Part,
			Serial) Inventory
	join object on Inventory.Serial = object.serial
	join part_online on Inventory.part = part_online.part
where	Inventory.QtyIssue + Inventory.QtyOverage > 0

select	@Error = @@Error

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end

--	IV.	Negative defect for quantity discrepency.
insert	Defects
(	TransactionDT,
	Machine,
	Part,
	DefectCode,
	QtyScrapped,
	Operator,
	Shift,
	WODID,
	DefectSerial)
select	TransactionDT = @TranDT,
	Machine = @Machine,
	Part = object.part,
	DefectCode = 'Qty Disc',
	QtyScrapped = -Inventory.QtyOverage,
	Operator = @Operator,
	Shift = @Shift,
	WODID = @WODID,
	DefectSerial = object.serial
from	(	select	Part,
			Serial,
			QtyOverage = sum (QtyOverage)
		from	@Inventory
		group by
			Part,
			Serial) Inventory
	join object on Inventory.Serial = object.serial
	join part_online on Inventory.part = part_online.part
where	Inventory.QtyOverage > 0

select	@Error = @@Error

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end

--	V.	Adjust inventory
--		A.	Update objects.
update	object
set	quantity = object.quantity - Inventory.QtyIssue,
	std_quantity = object.std_quantity - Inventory.QtyIssue
from	object
	join
	(	select	Serial,
			QtyIssue = sum (QtyIssue)
		from	@Inventory
		group by
			Serial) Inventory on object.serial = Inventory.Serial
where	object.std_quantity >= Inventory.QtyIssue

select	@Error = @@Error

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end

--		B.	Set depleted objects to empty (they will be deleted when the allocation is ended if operator quantity is 0).
update	object
set	quantity = 0,
	std_quantity = 0
from	object
	join
	(	select	Serial,
			QtyIssue = sum (QtyIssue)
		from	@Inventory
		group by
			Serial) Inventory on object.serial = Inventory.Serial
where	object.std_quantity < Inventory.QtyIssue

select	@Error = @@Error

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end

--	VI.	Update on hand for part.
update	part_online
set	on_hand =
	(	select	Sum (std_quantity)
		from	object
		where	part = part_online.part and
			status = 'A')
where	part in
	(	select	Part
		from	@Inventory)

select	@Error = @@Error

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end

--	VII.	Record back flush details.
insert	BackFlushDetails
(	BFID,
	BOMID,
	PartConsumed,
	SerialConsumed,
	QtyAvailable,
	QtyRequired,
	QtyIssue,
	QtyOverage)
select	BFID = @BFID,
	BOMID = Inventory.BOMID,
	PartConsumed = Inventory.Part,
	SerialConsumed = Inventory.Serial,
	QtyAvailable = Inventory.QtyAvailable,
	QtyRequired = Inventory.QtyRequired,
	QtyIssue = Inventory.QtyIssue,
	QtyOverage = Inventory.QtyOverage
from	@Inventory Inventory

select	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end
if	@RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end

--	VIII.	Update material allocation.
update	WODMaterialAllocations
set	WODMaterialAllocations.QtyIssued = WODMaterialAllocations.QtyIssued + Inventory.QtyIssue,
	WODMaterialAllocations.QtyOverage = WODMaterialAllocations.QtyOverage + Inventory.QtyOverage
from	WODMaterialAllocations
	join @Inventory Inventory on coalesce (WODMaterialAllocations.BOMID, -1) = Inventory.BOMID and
		 coalesce (WODMaterialAllocations.Suffix, 0) = Inventory.Suffix
where	WODMaterialAllocations.WODID = @WODID and
	WODMaterialAllocations.QtyEnd is null

select	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end
if	@RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'BackFlush')
	rollback tran BackFlush
	return	@Result
end

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction BackFlush
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IX.	Success.
set	@Result = 0
return	@Result
GO

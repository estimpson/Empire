SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ProdControl_Scrap]
    @Operator varchar(10)
,   @WODID int
,   @Serial int
,   @QtyScrap numeric(20, 6)
,   @DefectCode varchar(10)
,   @Result int out
as
/*
begin transaction
declare	@ProcResult int,
	@ProcReturn int
--9400446, 9388752 
execute	@ProcReturn = [FT].[ftsp_ProdControl_Scrap]
	@Operator = 'MON',
	@WODID = 403,
	@Serial = 812086,
	@QtyScrap = 151,
	@DefectCode = 'Incom box',
	@Result = @ProcResult out

select	@ProcReturn, @ProcResult

rollback
*/

set nocount on
set	@Result = 999999

--- <Error Handling>
declare
    @CallProcName sysname
,   @TableName sysname
,   @ProcName sysname
,   @ProcReturn integer
,   @ProcResult integer
,   @Error integer
,   @RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=No>
declare
	@TranCount smallint
,	@TranDT datetime

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

--	Argument Validation:
--		Operator required:
if	not exists
	(	select	1
		from	employee
		where	operator_code = @Operator) begin

	set	@Result = 60001
	rollback tran @ProcName
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

--		WOD ID must be valid.
declare	@PartProduce varchar (25)
if	not exists
	(	select	1
		from	WODetails
		where	ID = @WODID) begin
	
	set	@Result = 200101
	rollback tran @ProcName
	RAISERROR (@Result, 16, 1, @WODID)
	return	@Result
end

--		Defect code must be valid.
if	not exists
	(	select	1
		from	defect_codes
		where	code = @DefectCode) begin
	
	set	@Result = 60101
	rollback tran @ProcName
	RAISERROR (@Result, 16, 1, @DefectCode)
	return	@Result
end

--		Quantity must be valid.
if	not coalesce (@QtyScrap, 0) > 0 begin
	
	set	@Result = 202001
	rollback tran @ProcName
	RAISERROR (@Result, 16, 1, @QtyScrap)
	return	@Result
end

--	I.	Report overage for scrap in excess of material.
declare	@QtyOverage numeric (20,6)

set	@QtyOverage = @QtyScrap - coalesce (
	(	select	std_quantity
		from	object
		where	serial = @Serial), 0)

--		A.	Create object if it doesn't exist.
declare	@WOID int

select	@WOID = WOID
from	WODetails
where	ID = @WODID

insert	object
(	serial, part, location, last_date, quantity, po_number, operator,
	lot, weight, status, shipper, unit_measure, workorder,
	std_quantity, cost, custom1, custom2, custom3, custom4, custom5, plant,
	package_type, suffix, date_due, std_cost, user_defined_status,
	engineering_level, parent_serial, origin, destination, sequence, type,
	name, start_date, field1, field2, show_on_shipper, tare_weight,
	kanban_number, dimension_qty_string, dim_qty_string_other, varying_dimension_code)
select	serial = LastTrans.serial, part = LastTrans.part, location = 'Qty Excess',
	last_date = @TranDT, quantity = -@QtyOverage,
	po_number = LastTrans.po_number, operator = @Operator,
	lot = LastTrans.lot, weight = LastTrans.weight, status = 'S', shipper = LastTrans.shipper, unit = LastTrans.unit,
	workorder = convert (varchar, @WOID),
	std_quantity = -@QtyOverage, cost = LastTrans.cost, custom1 = LastTrans.custom1, custom2 = LastTrans.custom2,
	custom3 = LastTrans.custom3, custom4 = LastTrans.custom4, custom5 = LastTrans.custom5, plant = LastTrans.plant,
	package_type = LastTrans.package_type, suffix = LastTrans.suffix,
	date_due = LastTrans.due_date, std_cost = LastTrans.std_cost, user_defined_status = 'Scrap',
	engineering_level = LastTrans.engineering_level, parent_serial = LastTrans.parent_serial, origin = LastTrans.origin,
	destination = LastTrans.destination, sequence = LastTrans.sequence, type = LastTrans.object_type,
	name = LastTrans.part_name, start_date = LastTrans.start_date, field1 = LastTrans.field1, field2 = LastTrans.field2,
	show_on_shipper = LastTrans.show_on_shipper, tare_weight = LastTrans.tare_weight,
	kanban_number = LastTrans.kanban_number, dimension_qty_string = LastTrans.dimension_qty_string,
	dim_qty_string_other = LastTrans.dim_qty_string_other, varying_dimension_code = LastTrans.varying_dimension_code
from	audit_trail LastTrans
	join part_online on LastTrans.part = part_online.part
	join WODetails on WODetails.ID = @WODID
where	LastTrans.serial = @Serial and
	LastTrans.id =
	(	select	max (id)
		from	audit_trail
		where	serial = @Serial) and
	not exists
	(	select	1
		from	object
		where	object.serial = @Serial)

select	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_Scrap')
	rollback tran @ProcName
	return	@Result
end

--		B.	Report negative defect for excess inventory.
Declare @Audit_trailID_Excess int

insert	audit_trail
(	serial, date_stamp, type, part, quantity, remarks, po_number, operator,
	from_loc, to_loc, on_hand, lot, weight, status, shipper, unit, workorder,
	std_quantity, cost, custom1, custom2, custom3, custom4, custom5, plant,
	notes, package_type, suffix, due_date, std_cost, user_defined_status,
	engineering_level, parent_serial, origin, destination, sequence, object_type,
	part_name, start_date, field1, field2, show_on_shipper, tare_weight,
	kanban_number, dimension_qty_string, dim_qty_string_other, varying_dimension_code)
select	serial = object.serial, date_stamp = @TranDT, type = 'E', part = object.part, quantity = -@QtyOverage,
	remarks = 'Qty Excess', po_number = object.po_number, operator = @Operator,
	from_loc = object.location, to_loc = 'Scrap', on_hand = part_online.on_hand, lot = object.lot,
	weight = object.weight, status = 'S', shipper = object.shipper, unit = object.unit_measure, workorder = convert (varchar, @WOID),
	std_quantity = -@QtyOverage, cost = object.cost, custom1 = object.custom1, custom2 = object.custom2,
	custom3 = object.custom3, custom4 = object.custom4, custom5 = object.custom5, plant = object.plant,
	notes = 'Quantity Excess during backflush', package_type = object.package_type, suffix = object.suffix,
	due_date = object.date_due, std_cost = object.std_cost, user_defined_status = 'Scrap',
	engineering_level = object.engineering_level, parent_serial = object.parent_serial, origin = object.origin,
	destination = object.destination, sequence = object.sequence, object_type = object.type,
	part_name = object.name, start_date = object.start_date, field1 = object.field1, field2 = object.field2,
	show_on_shipper = object.show_on_shipper, tare_weight = object.tare_weight,
	kanban_number = object.kanban_number, dimension_qty_string = object.dimension_qty_string,
	dim_qty_string_other = object.dim_qty_string_other, varying_dimension_code = object.varying_dimension_code
from	object
	join part_online on object.part = part_online.part
where	object.serial = @Serial and
	@QtyOverage > 0

select	@Error = @@Error,
	@RowCount = @@Rowcount,
	@Audit_trailID_Excess = SCOPE_IDENTITY() 

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_Scrap')
	rollback tran @ProcName
	return	@Result
end

--	II.	Report quality transaction.

declare @DefectType char(1),
		@Audit_TrailID_Defect int

set	@DefectType = 'Q'

insert
	audit_trail
(	serial, date_stamp, type, part, quantity, remarks, po_number, operator,
	from_loc, to_loc, on_hand, lot, weight, status, shipper, unit, workorder,
	std_quantity, cost, custom1, custom2, custom3, custom4, custom5, plant,
	notes, package_type, suffix, due_date, std_cost, user_defined_status,
	engineering_level, parent_serial, origin, destination, sequence, object_type,
	part_name, start_date, field1, field2, show_on_shipper, tare_weight,
	kanban_number, dimension_qty_string, dim_qty_string_other, varying_dimension_code)
select	serial = object.serial, date_stamp = @TranDT, type = @DefectType, part = object.part, quantity = @QtyScrap,
	remarks = 'Quality', po_number = object.po_number, operator = @Operator,
	from_loc = object.status, to_loc = 'S', on_hand = part_online.on_hand - @QtyScrap, lot = object.lot,
	weight = object.weight, status = object.status, shipper = object.shipper, unit = object.unit_measure, workorder = convert (varchar, @WOID),
	std_quantity = @QtyScrap, cost = object.cost, custom1 = object.custom1, custom2 = object.custom2,
	custom3 = object.custom3, custom4 = object.custom4, custom5 = object.custom5, plant = object.plant,
	notes = 'PIBS Defect: ' + @DefectCode, package_type = object.package_type, suffix = object.suffix,
	due_date = object.date_due, std_cost = object.std_cost, user_defined_status = object.user_defined_status,
	engineering_level = object.engineering_level, parent_serial = object.parent_serial, origin = object.origin,
	destination = object.destination, sequence = object.sequence, object_type = object.type,
	part_name = object.name, start_date = object.start_date, field1 = object.field1, field2 = object.field2,
	show_on_shipper = object.show_on_shipper, tare_weight = object.tare_weight,
	kanban_number = object.kanban_number, dimension_qty_string = object.dimension_qty_string,
	dim_qty_string_other = object.dim_qty_string_other, varying_dimension_code = object.varying_dimension_code
from
	object
	join part_online
		on object.part = part_online.part
where
	object.serial = @Serial and
	@DefectCode != 'Qty Short'

select
    @Error = @@Error
,   @RowCount = @@Rowcount
,   @Audit_TrailID_Defect = scope_identity() 

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_Scrap')
	rollback tran @ProcName
	return	@Result
end

--	III.	Report delete for scrap transaction.
declare	@Machine varchar (10),
	@Shift char (1)

select	@Machine = Machine
from	WOHeaders
where	ID = @WOID

select	@Shift = Shift
from	WOShift
where	WOID = @WOID

insert	audit_trail
(	serial, date_stamp, type, part, quantity, remarks, po_number, operator,
	from_loc, to_loc, on_hand, lot, weight, status, shipper, unit, workorder,
	std_quantity, cost, custom1, custom2, custom3, custom4, custom5, plant,
	notes, package_type, suffix, due_date, std_cost, user_defined_status,
	engineering_level, parent_serial, origin, destination, sequence, object_type,
	part_name, start_date, field1, field2, show_on_shipper, tare_weight,
	kanban_number, dimension_qty_string, dim_qty_string_other, varying_dimension_code)
select	serial = object.serial, date_stamp = @TranDT,
	type = case when @DefectCode = 'Qty Short' then 'E' else 'D' end,
	part = object.part,
	quantity = case when @DefectCode = 'Qty Short' then @QtyScrap else 0 end,
	remarks = case when @DefectCode = 'Qty Short' then 'Qty Discr' else 'Scrap' end,
	po_number = object.po_number, operator = @Operator,
	from_loc = @Machine, to_loc = @Machine, on_hand = part_online.on_hand - @QtyScrap, lot = object.lot,
	weight = object.weight, status = object.status, shipper = object.shipper, unit = object.unit_measure, workorder = convert (varchar, @WOID),
	std_quantity = case when @DefectCode = 'Qty Short' then @QtyScrap else 0 end,
	cost = object.cost, custom1 = object.custom1, custom2 = object.custom2,
	custom3 = object.custom3, custom4 = object.custom4, custom5 = object.custom5, plant = object.plant,
	notes = 'PIBS Defect: ' + @DefectCode, package_type = object.package_type, suffix = object.suffix,
	due_date = object.date_due, std_cost = object.std_cost, user_defined_status = object.user_defined_status,
	engineering_level = object.engineering_level, parent_serial = object.parent_serial, origin = object.origin,
	destination = object.destination, sequence = object.sequence, object_type = object.type,
	part_name = object.name, start_date = object.start_date, field1 = object.field1, field2 = object.field2,
	show_on_shipper = object.show_on_shipper, tare_weight = object.tare_weight,
	kanban_number = object.kanban_number, dimension_qty_string = object.dimension_qty_string,
	dim_qty_string_other = object.dim_qty_string_other, varying_dimension_code = object.varying_dimension_code
from	object
	join part_online on object.part = part_online.part
where	object.serial = @Serial

select
    @Error = @@Error
,   @RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_Scrap')
	rollback tran @ProcName
	return	@Result
end
if	@RowCount != 1 begin
	set	@Result = 999999
	rollback tran @ProcName
	RAISERROR (@Result, 16, 1, 'ProdControl_Scrap')
	return	@Result
end

--	IV.	Report defects.
--		A.	Negative defect for quantity discrepency.
insert
	FT.Defects
(	TransactionDT,
	Machine,
	Part,
	DefectCode,
	QtyScrapped,
	Operator,
	Shift,
	WODID,
	DefectSerial,
	AuditTrailID)
select	TransactionDT = @TranDT,
	Machine = @Machine,
	Part = object.part,
	DefectCode = 'Qty Excess',
	QtyScrapped = -@QtyOverage,
	Operator = @Operator,
	Shift =  @Shift,
	WODID = @WODID,
	DefectSerial = @Serial,
	@Audit_trailID_Excess
from	object
where	serial = @Serial and
	@QtyOverage > 0

select	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_Scrap')
	rollback tran @ProcName
	return	@Result
end

--		B.	Reported defect.
insert
	FT.Defects
(	TransactionDT,
	Machine,
	Part,
	DefectCode,
	QtyScrapped,
	Operator,
	Shift,
	WODID,
	DefectSerial,
	AuditTrailID )
select	TransactionDT = @TranDT,
	Machine = @Machine,
	Part = object.part,
	DefectCode = @DefectCode,
	QtyScrapped = @QtyScrap,
	Operator = @Operator,
	Shift =  @Shift,
	WODID = @WODID,
	DefectSerial = @Serial,
	@Audit_TrailID_Defect
from	object
where	serial = @Serial

select	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_Scrap')
	rollback tran @ProcName
	return	@Result
end
if	@RowCount != 1 begin
	set	@Result = 999999
	rollback tran @ProcName
	RAISERROR (@Result, 16, 1, 'ProdControl_Scrap')
	return	@Result
end

--	V.	Adjust inventory
--		A.	Update objects.
update	object
set	quantity = quantity - @QtyScrap,
	std_quantity = std_quantity - @QtyScrap
where	serial = @Serial

select	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_Scrap')
	rollback tran @ProcName
	return	@Result
end
if	@RowCount != 1 begin
	set	@Result = 999999
	rollback tran @ProcName
	RAISERROR (@Result, 16, 1, 'ProdControl_Scrap')
	return	@Result
end

--		B.	Delete depleted objects.
update
	o
set	quantity = 0
,	std_quantity = 0
from
	dbo.object o
where
	serial = @Serial
	and std_quantity <= 0

select
	@Error = @@Error
,	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_Scrap')
	rollback tran @ProcName
	return	@Result
end

--- <Delete rows="*">
set	@TableName = 'dbo.object'

delete
	o
from
	dbo.object o
where
	serial = @Serial
	and o.std_quantity = 0
	and o.quantity = 0

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Delete>

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction @ProcName
end
--</CloseTran Required=Yes AutoCreate=Yes>

set	@Result = 0
return	@Result
GO

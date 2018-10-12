SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ProdControl_JobComplete_New]
(	@Operator varchar (10),
	@WODID int = null,
	@PartProduce varchar (25) = null,
	@QtyRequested numeric (20,6),
	@Override tinyint = 0,
	@NewSerial int out,
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

execute	@ProcReturn = FT.ftsp_ProdControl_JobComplete_new
	@Operator = @Operator,
	@WODID = NULL,
	@PartProduce = 'PRE-GUI0046-HD05',
	@QtyRequested = @QtyRequested,
	@Override = @Override,
	@NewSerial = @NewSerial out,
	@Result = @ProcResult  out

select	@ProcResult,
	@NewSerial,
	@ProcReturn

select	*
from	BackFlushHeaders
where	SerialProduced = @NewSerial

select	*
from	BackFlushDetails
where	BFID in (select	id
				from	BackFlushHeaders
				where	SerialProduced = @NewSerial )

select	*
from	object
where	serial in
	(	select	SerialConsumed
		from	BackFlushDetails
		where	BFID in (select	id
				from	BackFlushHeaders
				where	SerialProduced = @NewSerial ))

rollback

*/
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction JobComplete
end
else	begin
	save transaction JobComplete
end
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer
--</Error Handling>

--	Argument Validation:
--		Operator required:
if	not exists
	(	select	1
		from	employee
		where	operator_code = @Operator) begin

	set	@Result = 60001
	rollback tran JobComplete
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

--		Quantity must be valid.
if	not coalesce (@QtyRequested, 0) > 0 begin
	
	set	@Result = 202001
	rollback tran JobComplete
	RAISERROR (@Result, 16, 1, @QtyRequested)
	return	@Result
end

--	I.	Calculate the maximum production quantity given allocated inventory.
if	FT.fn_MaterialSourceType (null, null, @PartProduce, null, null) = 'Allocation' begin
	declare	@QtyExpected numeric (20,6),
		@QtyMaximum numeric (20,6),
		@ConstrainedPart varchar (25)
	
	execute	@ProcReturn = FT.ftsp_ProdControl_ValidateMaterial
		@WODID = @WODID,
		@QtyExpected = @QtyExpected out,
		@QtyMaximum = @QtyMaximum out,
		@ConstrainedPart = @ConstrainedPart out,
		@Result = @ProcResult out
	
	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
		rollback tran JobComplete
		return	@Result
	end
	if	@ProcReturn != 0 begin
		set	@Result = 999999
		RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
		rollback tran JobComplete
		return	@Result
	end
	if	@ProcResult != 0 begin
		set	@Result = 999999
		RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
		rollback tran JobComplete
		return	@Result
	end
	
--	II.	Validate quantity.
	if	@QtyMaximum is null begin
		set	@Result = 201001
		rollback tran JobComplete
		RAISERROR (@Result, 16, 1, @ConstrainedPart)
		return	@Result
	end
	if	@QtyRequested > @QtyMaximum begin
		set	@Result = 201002
		rollback tran JobComplete
		RAISERROR (@Result, 16, 1, @ConstrainedPart)
		return	@Result
	end
	if	@QtyRequested > @QtyExpected and @Override !> 0 begin
		set	@Result = 201003
		rollback tran JobComplete
		RAISERROR (@Result, 16, 1, @ConstrainedPart)
		return	@Result
	end
end
else if	FT.fn_MaterialSourceType (null, @WODID, @PartProduce, null, null) = 'Kit' and
	exists
	(	select	1
		from	part_machine
		where	part = @PartProduce and
			machine = 'moldeo' ) begin
	
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
	from	FT.fn_GetBackflushDetails_Kit (@WODID, @QtyRequested)
	
	if	exists
		(	select 1
			from	@Inventory Inventory
				join part on part.part = Inventory.Part
			where	QtyOverage > 0) begin

		select	@ConstrainedPart = Inventory.Part
		from	@Inventory Inventory
			join part on part.Part = Inventory.Part
		where	QtyOverage > 0
		
		set	@Result = 201002
		rollback tran JobComplete
		RAISERROR (@Result, 16, 1, @ConstrainedPart)
		return	@Result
	end
end

--	III.	Write job complete.
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

--		B.	Insert object.
declare	@TranDT datetime
set	@TranDT = GetDate ()

insert	object
(	serial, part, lot, location, last_date, unit_measure, operator, status, cost, note,
	name, plant, quantity, last_time, std_quantity, custom1, custom2, custom3,
	custom4, custom5, user_defined_status, workorder, std_cost)
select	serial = @NewSerial, part = @PartProduce, lot = '', location = coalesce (WOHeaders.Machine, PrimaryMachine.machine),
	last_date = @TranDT,
	unit_measure = part_inventory.standard_unit, operator = @Operator, status =
	(	case when IsNull (part.quality_alert, 'N') = 'Y' then 'H'
			else 'A'
		end), cost = part_standard.cost_cum, note = '',
	name = part.name, plant = coalesce (WOMachinePlant.plant, PrimaryMachinePlant.plant),
	quantity = @QtyRequested, last_time = @TranDT,
	std_quantity = @QtyRequested, custom1 = '', custom2 = '', custom3 = '',
	custom4 = '', custom5 = '', user_defined_status =
	(	case when IsNull (part.quality_alert, 'N') = 'Y' then 'Hold'
			else 'Approved'
		end), workorder = convert (varchar, WOHeaders.ID), std_cost = part_standard.cost_cum
from	part
	left join WODetails on WODetails.ID = @WODID
	left join WOHeaders on WODetails.WOID = WOHeaders.ID
	join part_inventory on part_inventory.part = @PartProduce
	join part_standard on part_standard.part = @PartProduce
	left join location WOMachinePlant on WOHeaders.Machine = WOMachinePlant.code
	join part_machine PrimaryMachine on part.part = PrimaryMachine.part and
		PrimaryMachine.sequence = 1
	join location PrimaryMachinePlant on PrimaryMachine.machine = PrimaryMachinePlant.code
where	part.part = @PartProduce

set	@Error = @@Error
set	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
	rollback tran JobComplete
	return	@Result
end
if	@RowCount != 1 begin
	set	@Result = 999999
	rollback tran JobComplete
	RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
	return	@Result
end

--		C.	Update part_online.
update	part_online
set	on_hand =
	(	select	sum (std_quantity)
		from	object
		where	part = part_online.part and
			status = 'A')
from	part_online
	join object on part_online.part = object.part
where	object.serial = @NewSerial

set	@Error = @@Error
set	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
	rollback tran JobComplete
	return	@Result
end
if	@RowCount != 1 begin
	insert	part_online
	(	part, on_hand)
	select	part = part,
		on_hand = sum (std_quantity)
	from	object
	where	part =
		(	select	part
			from	object
			where	serial = @NewSerial) and
		status = 'A'
	group by
		part
	
	set	@Error = @@Error
	set	@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
		rollback tran JobComplete
		return	@Result
	end
	if	@RowCount != 1 begin
		set	@Result = 999999
		rollback tran JobComplete
		RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
		return	@Result
	end
end

--		D.	Insert audit_trail.
insert	audit_trail
(	serial, date_stamp, type, part, quantity, remarks, price,
	operator, from_loc, to_loc, on_hand, lot, weight, status, unit,
	workorder, std_quantity, cost, custom1, custom2, custom3,
	custom4, custom5, plant, notes, gl_account, std_cost,
	user_defined_status, part_name, tare_weight)
select	serial = object.serial, date_stamp = @TranDT, type = 'J', part = object.part,
	quantity = object.quantity, remarks = 'Job comp', price = 0,
	operator = object.operator, from_loc = object.location, to_loc = object.location,
	on_hand = IsNull (part_online.on_hand, 0) +
	(	case	when object.status = 'A' then object.std_quantity
			else 0
		end), lot = object.lot, weight = object.weight,
	status = object.status, unit = object.unit_measure,
	workorder = object.workorder, std_quantity = object.std_quantity, cost = object.cost,
	custom1 = object.custom1, custom2 = object.custom2, custom3 = object.custom3,
	custom4 = object.custom4, custom5 = object.custom5, plant = object.plant,
	notes = '', gl_account = '', std_cost = object.cost,
	user_defined_status = object.user_defined_status, part_name = object.name, tare_weight = object.tare_weight
from	object
	left outer join part_online on object.part = part_online.part
	join part on object.part = part.part
where	object.serial = @NewSerial

set	@Error = @@Error
set	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
	rollback tran JobComplete
	return	@Result
end
if	@RowCount != 1 begin
	set	@Result = 999999
	rollback tran JobComplete
	RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
	return	@Result
end

--	IV.	Perform back flush.
declare	@NewBFID int

--		A.	Create back flush header.
insert	BackFlushHeaders
(	WODID,
	PartProduced,
	SerialProduced,
	QtyProduced)
select	@WODID,
	@PartProduce,
	@NewSerial,
	@QtyRequested

set	@NewBFID = SCOPE_IDENTITY ()

--		B.	Execute back flush details.
execute	@ProcReturn = FT.ftsp_ProdControl_BackFlush_New
	@Operator = @Operator,
	@BFID = @NewBFID,
	@Result = @ProcResult out

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
	rollback tran JobComplete
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
	rollback tran JobComplete
	return	@Result
end
if	@ProcResult != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
	rollback tran JobComplete
	return	@Result
end

--	V.	Update workorder.
update	WODetails
set	QtyCompleted = QtyCompleted + @QtyRequested
where	ID = @WODID

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
	rollback tran JobComplete
	return	@Result
end

--	V.2 Update the Weekly WorkOrder QtyCompleted
exec	@ProcReturn = ft.ftsp_ProdControl_Update_QtyCompleted
		@WODID = @WODID,
		@QtyRequested = @QtyRequested,
		@Result = @ProcResult out

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
	rollback tran JobComplete
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
	rollback tran JobComplete
	return	@Result
end
if	@ProcResult != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_JobComplete')
	rollback tran JobComplete
	return	@Result
end


--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction JobComplete
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	VI.	Success.
set	@Result = 0
return	@Result
GO


if	objectproperty(object_id('EEA.ftsp_ProdControl_AllocateSerial'), 'IsProcedure') = 1 begin
	drop procedure EEA.ftsp_ProdControl_AllocateSerial
end
go

create procedure EEA.ftsp_ProdControl_AllocateSerial
	@Operator varchar (5),
	@WODID int,
	@Serial int,
	@Result int out
as
/*
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@Operator varchar (5),
	@WODID int,
	@Serial int

set	@Operator = 'MON'
set	@WODID = 7
set	@Serial = 10340225

execute	@ProcReturn = EEA.ftsp_ProdControl_AllocateSerial
	@Operator = @Operator,
	@WODID = @WODID,
	@Serial = @Serial,
	@Result = @ProcResult out

select	@ProcReturn,
	@ProcResult

select	*
from	WODMaterialAllocations
where	WODID = @WODID

rollback
*/
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction AllocateSerial
end
else	begin
	save transaction AllocateSerial
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
	rollback tran AllocateSerial
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

--		Object serial must be valid.
if	not exists
	(	select	1
		from	object
		where	serial = @Serial) begin

	set	@Result = 100001
	rollback tran AllocateSerial
	RAISERROR (@Result, 16, 1, @Serial)
	return	@Result
end

--		WOD ID must be valid.
declare	@PartProduce varchar (25)
if	not exists
	(	select	1
		from	WODetails
		where	ID = @WODID) begin
	
	set	@Result = 200101
	rollback tran AllocateSerial
	RAISERROR (@Result, 16, 1, @WODID)
	return	@Result
end

--		Serial must be valid for this bill of material.
select	@PartProduce = Part
from	WODetails
where	ID = @WODID

if	not exists
	(	select	1
		from	FT.XRt
		where	TopPart = @PartProduce and
			ChildPart =
			(	select	part
				from	object
				where	serial = @Serial)) begin
	
	set	@Result = 102001
	rollback tran AllocateSerial
	RAISERROR (@Result, 16, 1, @Serial, @PartProduce)
	return	@Result
end

--	I.	Create allocation.
update	WODMaterialAllocations
set	QtyEnd =
	(	select	std_quantity
		from	object
		where	serial = WODMaterialAllocations.Serial)
where	WODID = @WODID and
	Serial = @Serial

insert	WODMaterialAllocations
(	WODID,
	BOMID,
	Serial,
	QtyOriginal,
	QtyBegin,
	QtyIssued,
	QtyOverage)
select	WODID = @WODID,
	BOMID = XRt.BOMID,
	Serial = object.serial,
	QtyOriginal =
	coalesce(	(	select	Max(QtyBegin)
					from	WODMaterialAllocations
					where	WODMaterialAllocations.serial = object.serial),
				 object.std_quantity,
				(	select	std_quantity
					from	audit_trail
					where	serial = object.serial and
						date_stamp =
						(	select	min (date_stamp)
							from	audit_trail
							where	serial = object.serial))),
	QtyBegin = object.std_quantity,
	QtyIssued = 0,
	QtyOverage = 0
from	object
	join WODetails on WODetails.ID = @WODID
	join FT.XRt XRt on object.part = XRt.ChildPart and
		WODetails.Part = XRt.TopPart
where	object.serial = @Serial

set	@Error = @@Error
set	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_AllocateSerial')
	rollback tran AllocateSerial
	return	@Result
end

if	@RowCount !> 0 begin
	set	@Result = 999999
	rollback tran AllocateSerial
	RAISERROR (@Result, 16, 1, 'ProdControl_AllocateSerial')
	return	@Result
end

--		B.	Move inventory to the machine.
declare	@Machine varchar (10), @WOID int

select	@Machine = WOH.Machine,
		@WOID = WOH.id
from	WODetails WOD
	join WOHeaders WOH on WOD.WOID = WOH.ID
where	WOD.ID = @WODID

insert into audit_trail(
	serial, date_stamp, part, type, quantity, remarks, 
	from_loc, to_loc, workorder, operator,
	std_quantity, std_cost, cost, status, unit, plant)
select	serial, date_stamp = getdate(),
		part, type = 'T', quantity, 
		Remarks = 'Transfer', from_loc = location, to_loc = @Machine, 
		workorder = @WOID, operator = @Operator, std_quantity, 
		std_cost, cost, status,unit_measure, plant
from	object
where	Serial = @Serial


set	@Error = @@Error
set	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_AllocateSerialNew:Insert Transfer')
	rollback tran AllocateSerialNew
	return	@Result
end

if	@RowCount != 1 begin
	set	@Result = 999999
	rollback tran AllocateSerialNew
	RAISERROR (@Result, 16, 1, 'ProdControl_AllocateSerialNew:Insert Transfer')
	return	@Result
end


update	object
set	location = @Machine
where	serial = @Serial

set	@Error = @@Error
set	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_AllocateSerial')
	rollback tran AllocateSerial
	return	@Result
end
if	@RowCount != 1 begin
	set	@Result = 999999
	rollback tran AllocateSerial
	RAISERROR (@Result, 16, 1, 'ProdControl_AllocateSerial')
	return	@Result
end

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction AllocateSerial
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Success.
select	*
from	WODMaterialAllocations
where	WODID = @WODID

set	@Result = 0
return	@Result
go


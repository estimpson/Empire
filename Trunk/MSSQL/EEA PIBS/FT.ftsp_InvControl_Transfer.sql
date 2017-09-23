use MONITOR
go

if	objectproperty(object_id('FT.ftsp_InvControl_Transfer'), 'IsProcedure') = 1 begin
	drop procedure FT.ftsp_InvControl_Transfer
end
go

create procedure FT.ftsp_InvControl_Transfer
	@Operator varchar(5)
,	@Serial int
,	@NewLocation varchar(10) = 'ALA-DMCAGE'
,	@TranDT datetime = null out
,	@Result integer = 0 out
--<Debug>
,	@Debug integer = 0
--</Debug>
as

/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@FirstSerial int,
	@Serial int 

set @Serial = 5981231

select	Serial, Part, std_Quantity, Quantity, location
from	Object
where serial = @Serial

execute	@ProcReturn = FT.ftsp_InvControl_Transfer
	@Operator = 'MON',
	@Serial = @Serial,
	@QtyOfObjects = 1, 
	@QtyPerObject = 80,
	@NewLocation = null,
	@NewObjectSerial = @FirstSerial output,
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult


select	Serial, Part, std_Quantity, Quantity, location
from	object 
where	Serial  = @Serial

select	Part, std_Quantity, Quantity, *
from	Audit_trail
where	Serial  = @Serial and Type = 'B'

select	Part, std_Quantity, Quantity, location
from	object 
where	Serial  Between @FirstSerial and @FirstSerial + 3

select	Part, type, from_loc, to_loc, std_Quantity, Quantity
from	Audit_trail
where	Serial  Between @FirstSerial and @FirstSerial + 3


rollback
:End Example
*/

set nocount on
set @Result = 999999

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

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<Validation>
/*	Operator required. */
if	not exists
	(	select
			*
		from
			employee
		where
			operator_code = @Operator
	) begin

	set @Result = 60001
	rollback tran @ProcName		
	raiserror (@Result, 16, 1, @Operator)
	return	@Result
end

/*	Serial required. */
if	not exists
	(	select
			*
		from
			object
		where
			serial = @Serial
	) begin

	set @Result = 100001
	rollback tran @ProcName
	raiserror (@Result, 16, 1, @Serial)
	return	@Result
end

/*	Valid Transfer location. */
if	not exists
	(	select
			*
		 from
			location
		 where
			code = @NewLocation
	) begin
	
	set @Result = 90001
	rollback tran @ProcName
	raiserror (@Result, 16, 1, @NewLocation)
	return	@Result					  	
end

/*	Object has quantity remaining. */
declare
	@ObjectQuantity numeric(20, 6)
,   @Part varchar(25)
,	@OldLocation varchar(10)

select
    @ObjectQuantity = o.quantity
,   @Part = o.part
,	@OldLocation = o.location
from
    dbo.object o with (rowlock)
where
    o.serial = @Serial 
	
if	@ObjectQuantity !> 0 begin
	
    set @Result = 60001
    rollback tran @ProcName
    raiserror ('Invalid quantity of the object [%d]!', 16, 1, @ObjectQuantity)
    return	@Result
end

/*	Move object to new location. */
--- <Update rows="1">
set	@TableName = '[tableName]'

update
	o
set
	operator = @Operator
,	location = @NewLocation
,	last_date = @TranDT
,	last_time = @TranDT
,	status = 'H'
,	user_defined_status = 'Hold'
from
	dbo.object o
where
	o.serial = @Serial

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 1 begin
	set	@Result = 999999
	RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>

/*	Write audit trail. */
--- <Insert rows=1>
set	@TableName = 'dbo.audit_trail'

insert
	audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	operator
,	from_loc
,	to_loc
,	lot
,	weight
,	status
,	unit
,	std_quantity
,	plant
,	notes
,	package_type
,	std_cost
,	user_defined_status
,	tare_weight
,	Custom1
,	start_date
,	field1 
)
select
	o.serial
,   @TranDT
,   type = 'T'
,   o.part
,   o.quantity
,   remarks = 'Transfer'
,   o.operator
,   from_loc = @OldLocation
,   to_loc = o.location
,   o.lot
,   o.weight
,   o.status
,   o.unit_measure
,   o.std_quantity
,   o.plant
,   o.note
,   o.package_type
,   o.cost
,   o.user_defined_status
,   o.tare_weight
,   o.custom1
,   o.start_date
,   o.field1
from
	dbo.object o
where
	o.serial = @Serial

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 1 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction @ProcName
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
set	@Result = 0
return	@Result
go


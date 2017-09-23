SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_InvControl_BreakOut]
	@Operator varchar(5)
,	@Serial int
,	@QtyOfObjects int
,	@QtyPerObject numeric(20, 6)
,	@Location varchar(10) = null
,	@NewObjectSerial int = null out
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

execute	@ProcReturn = FT.ftsp_InvControl_BreakOut
	@Operator = 'MON',
	@Serial = @Serial,
	@QtyOfObjects = 1, 
	@QtyPerObject = 80,
	@Location = null,
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
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

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
			1
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
			1
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

/*	Quantity > 0. */
if	@QtyPerObject !> 0 begin

    set @Result = 60001
    rollback tran @ProcName
    raiserror ('Invalid quantity [%d]!', 16, 1, @QtyPerObject)
    return	@Result
end

/*	Valid breakout location. */
declare
	@ObjectQuantity numeric(20, 6)
,   @Part varchar(25)

select
    @Location = isnull(@Location, location)
,   @ObjectQuantity = Quantity
,   @Part = Part
from
    Object with (rowlock)
where
    Serial = @Serial 
	
if	not exists
	(	select
			1
		 from
			location
		 where
			code = @Location
	) begin
	
	set @Result = 90001
	rollback tran @ProcName
	raiserror (@Result, 16, 1, @Location)
	return	@Result					  	
end
	
/*	Object has quantity remaining. */
if	@ObjectQuantity !> 0 begin
	
    set @Result = 60001
    rollback tran @ProcName
    raiserror ('Invalid quantity of the object [%d]!', 16, 1, @ObjectQuantity)
    return	@Result
end

/*	Object quantity isn't exceeded by quantity to breakout. */
if (@QtyPerObject * @QtyOfObjects) > @ObjectQuantity begin
    set @Result = 60001
    rollback tran @ProcName
    raiserror ('Quantity requested is grater than the original object', 16, 1)
    return	@Result
end

--- <Body>
/*	Get a block of serial numbers. */
--<Debug>
if	@Debug & 1 = 1 begin
	print	'I.	Get a block of serial numbers.'
end
--</Debug>

--- <Call>	
set	@CallProcName = 'monitor.usp_NewSerialBlock'
execute
	@ProcReturn = monitor.usp_NewSerialBlock
	@SerialBlockSize = @QtyOfObjects
,	@FirstNewSerial = @NewObjectSerial out
,	@Result = @ProcResult out

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcResult != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>

/*	Create objects. */
--- <Insert rows=n>
set	@TableName = 'dbo.object'

insert
	object
(	serial
,	part
,	quantity
,	std_quantity
,	lot
,	location
,	last_date
,	unit_measure
,	operator
,	status
,	plant
,	name
,	last_time
,	start_date
,	user_defined_status
,	cost
,	std_cost
,	Custom1
,	field1
,	note
)
select
    @NewObjectSerial + r.RowNumber - 1
,   part
,   @QtyPerObject
,   @QtyPerObject
,   lot
,   @Location
,   @TranDT
,   unit_measure
,   @Operator
,   status
,   plant
,   name
,   @TranDT
,   start_date
,   user_defined_status
,   cost
,   std_cost
,   Custom1
,   field1
,   note
from
    dbo.object o
    cross join FT.udf_Rows(@QtyOfObjects) r
where
    Serial = @Serial

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != @QtyOfObjects begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, @QtyOfObjects)
	rollback tran @ProcName
	return
end
--- </Insert>

/*	Write audit trail. */
--- <Insert rows=n>
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
	serial
,   @TranDT
,   type = 'B'
,   part
,   quantity
,   remarks = 'Break'
,   operator
,   from_loc = convert(varchar, @Serial)
,   to_loc = location
,   lot
,   weight
,   status
,   unit_measure
,   std_quantity
,   plant
,   Note
,   package_type
,   cost
,   user_defined_status
,   tare_weight
,   Custom1
,   start_date
,   field1
from
	object
where
	object.serial between @NewObjectSerial and @NewObjectSerial + @QtyOfObjects - 1

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != @QtyOfObjects begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, @QtyOfObjects)
	rollback tran @ProcName
	return
end
--- </Insert>


/*	Decrease the quantity of the breakout object. */
--- <Update rows="1">
set	@TableName = 'dbo.object'

update
	o
set	quantity = quantity - (@QtyPerObject * @QtyOfObjects)
,	std_quantity = std_quantity - (@QtyPerObject * @QtyOfObjects)
,	last_date = @TranDT
,	operator = @Operator
,	last_time = @TranDT
from
	dbo.object o
where
	serial = @Serial

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

/*	Write to audit_trail. */
--- <Insert rows="1">
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
,	custom2
,	start_date 
)
select
    serial
,   @TranDT
,   type = 'B'
,   part
,   quantity
,   Remark = 'Break-Out'
,   operator
,   from_loc = location
,   to_loc = convert(varchar, @NewObjectSerial)
,   lot
,   weight
,   status
,   unit_measure
,   std_quantity
,   plant
,   Note
,   package_type
,   cost
,   user_defined_status
,   tare_weight
,   Custom1 = ''
,   custom2 = convert(varchar, (@QtyPerObject * @QtyOfObjects))
,   start_date
from
    object object
where
    object.serial = @Serial

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

/*	If the serial is depleted delete the breakout object. */
if  (	select
			isnull(Quantity,0)
		from
			dbo.object
		where
			Serial = @Serial
	) = 0 begin

	--- <Delete rows="1">
	set	@TableName = 'dbo.object'

	delete
		o
	from
		dbo.object o
	where
		serial = @Serial

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Rows deleted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Delete>
end

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction @ProcName
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
set	@Result = 0
return	@Result
GO

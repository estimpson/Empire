SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [HN].[SP_Inventory_RF_Transfer]
	@Operator varchar(5)
,	@Serial int
,	@NewLocation varchar(10) = 'ALA-DMCAGE'
,	@Result integer = 0 out
--<Debug>
,	@Debug integer = 0
--</Debug>
as
BEGIN

SET nocount ON
set	@Result = 999999
DECLARE @ProcName  sysname

set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test

--<Tran Required=Yes AutoCreate=Yes>
	DECLARE	@TranCount SMALLINT
	SET	@TranCount = @@TranCount
	IF	@TranCount = 0 
		BEGIN TRANSACTION @ProcName
	ELSE
		SAVE TRANSACTION @ProcName
--</Tran>

--<Error Handling>
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer

declare @TranDT datetime, @TableName as varchar(25)
set	@TranDT =  GetDate()
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

/*	Object has same location. */
if @OldLocation = @NewLocation 
begin
	
    set @Result = 60001
    rollback tran @ProcName
    raiserror ('This serial was transfer to this location!', 16, 1, @ObjectQuantity)
    return	@Result
end

/*	Stage location is blocking  */
if @OldLocation like '%stage' or  @NewLocation like '%stage' 
begin
	
    set @Result = 60001
    rollback tran @ProcName
    raiserror ('You can not move serial FROM or TO Stage location !', 16, 1, @ObjectQuantity)
    return	@Result
end


/*	Move object to new location. */
--- <Update rows="1">
set	@TableName = 'dbo.object'

update
	o
set
	operator = @Operator
,	location = @NewLocation
,	last_date = @TranDT
,	last_time = @TranDT
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
end
GO

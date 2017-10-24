SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[usp_InvControl_CombinePallet]
	@User varchar(5)
,	@PalletSerialFrom int
,	@PalletSerialTo int
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FT.usp_Test
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

---	<ArgumentValidation>
-- Valid operator.
if	not exists
	(	select
			*
		from
			employee
		where
			operator_code = @User
	) begin

	set	@Result = 60001
	rollback tran @ProcName
	RAISERROR ('Error in procedure %s. Operator %s not found.', 16, 1, @ProcName, @User)
	return	@Result
end

-- Pallet serial "from" exists.
if	not exists
	(	select
			*  
		from
			object
		where
			serial = @PalletSerialFrom
	) begin
	
	set	@Result = 60002
	rollback tran @ProcName
	RAISERROR ('Error in procedure %s. Serial %s not found.', 16, 1, @ProcName, @PalletSerialFrom)
	return	@Result
end

-- Pallet serial number "from" is a pallet.
if not exists
	(	select
			*
		from
			object
		where
			serial = @PalletSerialFrom
			and type = 'S'
	) begin
	
	set	@Result = 60003
	rollback tran @ProcName
	RAISERROR ('Error in procedure %s. Serial %s is not a pallet.', 16, 1, @ProcName, @PalletSerialFrom)
	return	@Result
end

-- Pallet serial "to" exists.
if	not exists
	(	select
			*  
		from
			object
		where
			serial = @PalletSerialTo
	) begin
	
	set	@Result = 60002
	rollback tran @ProcName
	RAISERROR ('Error in procedure %s. Serial %s not found.', 16, 1, @ProcName, @PalletSerialTo)
	return	@Result
end

-- Pallet serial number "to" is a pallet.
if not exists
	(	select
			*
		from
			object
		where
			serial = @PalletSerialTo
			and type = 'S'
	) begin
	
	set	@Result = 60003
	rollback tran @ProcName
	RAISERROR ('Error in procedure %s. Serial %s is not a pallet.', 16, 1, @ProcName, @PalletSerialTo)
	return	@Result
end
---	</ArgumentValidation>

--- <Body>
/*	Get a list of all objects being moved.  Empty pallets can be combined from but will only result in the pallet being removed. */
declare
	@objectList table
(	BoxSerial int primary key
)

insert
	@objectList
(	BoxSerial
)
select
	BoxSerial = oBox.serial
from
	dbo.object oBox
where
	oBox.parent_serial = @PalletSerialFrom

/*	Move boxes to the new pallet. */
--- <Update rows="*">
set	@TableName = 'dbo.object o'

update
	oBox
set
	parent_serial = @PalletSerialTo
,	location = oNewPallet.location
from
	dbo.object oBox
		join dbo.object oNewPallet
			on oNewPallet.serial = @PalletSerialTo
where
	oBox.parent_serial = @PalletSerialFrom

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>

/*	Write audit trail. */
--- <Insert rows=2>
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
,   type = 'C'
,   o.part
,   o.quantity
,   remarks = 'Combine'
,   o.operator
,   from_loc = convert(varchar(10), @PalletSerialFrom)
,   to_loc = convert(varchar(10), @PalletSerialTo)
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
	o.serial in (@PalletSerialFrom, @PalletSerialTo)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 2 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 2.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>

/*	Delete old pallet. */
--- <Delete rows="1">
set	@TableName = 'dbo.object'

delete
	o
from
	dbo.object o
where
	o.serial = @PalletSerialFrom

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
--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@User varchar(5)
,	@PalletSerialFrom int = 1132161
,	@PalletSerialTo int = 1131905

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.usp_InvControl_CombinePallet
	@Param1 = @Param1
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO

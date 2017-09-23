
/*
Create Procedure.Fx.FT.usp_InvControl_NewPallet.sql
*/

--use Fx
--go

if	objectproperty(object_id('FT.usp_InvControl_NewPallet'), 'IsProcedure') = 1 begin
	drop procedure FT.usp_InvControl_NewPallet
end
go

create procedure FT.usp_InvControl_NewPallet
	@Operator varchar(10)
,	@PalletLocation varchar(10)
,	@PalletSerial int out
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
--		Operator required:
if	not exists
	(	select	1
		from	employee
		where	operator_code = @Operator) begin

	set	@Result = 60001
	rollback tran ProdControlNewPreObject
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

---	</ArgumentValidation>

--- <Body>
/*	Get a serial for the pallet. */
declare
	@newPalletSerial int

select
	@newPalletSerial = next_serial
from
	parameters with (tablockx)

while exists
	(	select
			serial
		from
			object
		where
			serial = @newPalletSerial
	)
	or exists
	(	select
			serial
		from
			audit_trail
		where
			serial = @newPalletSerial
	) begin

	set @newPalletSerial = @newPalletSerial + 1
end

update
	parameters
set next_serial = @newPalletSerial + 1

/*	Create pallet object. */
--- <Insert rows="1">
set	@TableName = 'dbo.object'

insert
	dbo.object
(	serial
,	part
,	location
,	last_date
,	last_time
,	operator
,	status
,	type
,	plant
)
select
	serial = @newPalletSerial
,	part = 'PALLET'
,	location = @PalletLocation
,	last_date = @TranDT
,	last_time = @TranDT
,	operator = @Operator
,	status = 'A'
,	type = 'S'
,	plant
from
	location
where
	location.code = @PalletLocation

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

/*	Create audit trail. */
--- <Insert rows="1">
set	@TableName = 'dbo.audit_trail'

insert
	dbo.audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	price
,	operator
,	from_loc
,	to_loc
,	status
,	plant
,	object_type
)	
select
	serial = o.serial
,	date_stamp = @TranDT
,	type = 'P'
,	part = 'PALLET'
,	quantity = 0
,	remarks = 'New Pallet'
,	price = 0
,	operator = @Operator
,	from_loc = o.location
,	to_loc = o.location
,	status = o.status
,	plant = o.plant
,	object_type = o.type
from
	dbo.object o
where
	o.serial = @newPalletSerial

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

set	@PalletSerial = @newPalletSerial
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
	@Operator varchar(10)
,	@PalletLocation varchar(10)
,	@PalletSerial int

set	@Operator = 'ES'
set	@PalletLocation = 'ALA-FINAUD'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.usp_InvControl_NewPallet
	@Operator = @Operator
,	@PalletLocation = @PalletLocation
,	@PalletSerial = @PalletSerial out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	dbo.object o
where
	o.serial = @PalletSerial

select
	*
from
	dbo.audit_trail at
where
	at.serial = @PalletSerial
	and at.date_stamp = @TranDT
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
go


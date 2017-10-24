/*
Create Procedure.MONITOR.FT.usp_InvControl_TransferPallet.sql
*/

use MONITOR
go

if	objectproperty(object_id('FT.usp_InvControl_TransferPallet'), 'IsProcedure') = 1 begin
	drop procedure FT.usp_InvControl_TransferPallet
end
go

create procedure FT.usp_InvControl_TransferPallet
	@Operator varchar(5)
,	@PalletSerial int
,	@Location varchar(10)
,	@Notes varchar(254) = null
,	@TranDT datetime out
,	@Result integer out
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
	@RowCount integer,
	@FirstNewSerial integer

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

---	<ArgumentValidation>
-- Valid operator.
if	not exists
	(	select	1
		from	employee
		where	operator_code = @Operator) begin

	set	@Result = 60001
	rollback tran @ProcName
	RAISERROR ('Error in procedure %s. Operator %s not found.', 16, 1, @ProcName, @Operator)
	return	@Result
end

-- Valid location.
if	not exists
	(	select	1
		from	location
		where	code = @Location) begin

	set	@Result = 60001
	rollback tran @ProcName
	RAISERROR ('Error in procedure %s. %s is not a valid location.', 16, 1, @ProcName, @Location)
	return	@Result
end

-- Pallet serial exists.
if not exists
	(	select	1 
		from	object
		where	serial = @PalletSerial) begin
	
	set	@Result = 60002
	rollback tran @ProcName
	RAISERROR ('Error in procedure %s. Serial %s not found.', 16, 1, @ProcName, @PalletSerial)
	return	@Result
end

-- Pallet serial number is a pallet.
if not exists
	(	select	1 
		from	object
		where	serial = @PalletSerial
				and type = 'S') begin
	
	set	@Result = 60003
	rollback tran @ProcName
	RAISERROR ('Error in procedure %s. Serial %d is not a pallet.', 16, 1, @ProcName, @PalletSerial)
	return	@Result
end

-- Is not already at the location.
if exists
	(	select
			*
		from
			object
		where
			serial = @PalletSerial
			and location = @Location
	) begin

	set	@Result = 100
	rollback tran @ProcName
	RAISERROR ('Warning in procedure %s. Pallet %d is already at location %s.', 10, 1, @ProcName, @PalletSerial, @Location)
	return
		100
end
---	</ArgumentValidation>


--- <Body>
--- Store original location
declare @LocationOriginal varchar(10)
select
	@LocationOriginal = o.location
from
	object o
where
	o.serial = @PalletSerial
	

--- Get a count of the number of boxes on the pallet for error reporting
declare @NumberOfBoxes int
declare @TotalObjects int

select
	@NumberOfBoxes = COUNT(1)
from
	object o
where
	o.parent_serial = @PalletSerial

set @TotalObjects = @NumberOfBoxes + 1


--- <Update location of pallet and boxes on pallet>
set	@TableName = 'dbo.object'
update 
	o
set
	o.location = @Location
from
	object o
where
	o.serial = @PalletSerial
	or o.parent_serial = @PalletSerial
	
select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999997
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount = 0 begin
	set	@Result = 999998
	RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, @TotalObjects)
	rollback tran @ProcName
	return
end
--- </Update location of pallet and boxes on pallet>


--- <Create transfer record for pallet>
set	@TableName = 'dbo.audit_trail'
insert
	dbo.audit_trail
(	serial
,   date_stamp
,   type
,   part
,   quantity
,   remarks
,   price
,   salesman
,   customer
,   vendor
,   po_number
,   operator
,   from_loc
,   to_loc
,   on_hand
,   lot
,   weight
,   status
,   shipper
,   flag
,   activity
,   unit
,   workorder
,   std_quantity
,   cost
,   control_number
,   custom1
,   custom2
,   custom3
,   custom4
,   custom5
,   plant
,   invoice_number
,   notes
,   gl_account
,   package_type
,   suffix
,   due_date
,   group_no
,   sales_order
,   release_no
,   dropship_shipper
,   std_cost
,   user_defined_status
,   engineering_level
,   posted
,   parent_serial
,   origin
,   destination
,   sequence
,   object_type
,   part_name
,   start_date
,   field1
,   field2
,   show_on_shipper
,   tare_weight
,   kanban_number
,   dimension_qty_string
,   dim_qty_string_other
,   varying_dimension_code
)
select 
	serial = o.serial
,   date_stamp = @TranDT
,   type = 'T'
,   part = o.part
,   quantity = o.quantity
,   remarks = 'Transfer'
,   price = 0
,   salesman = ''
,   customer = ''
,   vendor = ''
,   po_number = ''
,   operator = @Operator
,   from_loc = @LocationOriginal
,   to_loc = o.location
,   on_hand = null
,   lot = o.Lot
,   weight = o.weight
,   status = o.status
,   shipper = o.origin
,   flag = ''
,   activity = ''
,   unit = o.unit_measure
,   workorder = o.workorder
,   std_quantity = o.std_quantity
,   cost = o.Cost
,   control_number = ''
,   custom1 = o.custom1
,   custom2 = o.custom2
,   custom3 = o.custom3
,   custom4 = o.custom4
,   custom5 = o.custom5
,   plant = o.plant
,   invoice_number = ''
,   notes = @Notes
,   gl_account = ''
,   package_type = o.package_type
,   suffix = null
,   due_date = null
,   group_no = ''
,   sales_order = ''
,   release_no = ''
,   dropship_shipper = 0
,   std_cost = o.std_cost
,   user_defined_status = o.user_defined_status
,   engineering_level = ''
,   posted = null
,   parent_serial = null
,   origin = o.origin
,   destination = ''
,   sequence = null
,   object_type = null
,   part_name = null
,   start_date = null
,   field1 = o.field1
,   field2 = o.field2
,   show_on_shipper = o.show_on_shipper
,   tare_weight = null
,   kanban_number = null
,   dimension_qty_string = null
,   dim_qty_string_other = null
,   varying_dimension_Code = null
from
	object o
where
	o.serial = @PalletSerial

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 100020
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 1 begin
	set	@Result = 100021
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Create transfer record for pallet>


--- <Create transfer records for boxes on pallet>
if (@NumberOfBoxes > 0) begin
		
	set	@TableName = 'dbo.audit_trail'
	insert
		dbo.audit_trail
	(	serial
	,   date_stamp
	,   type
	,   part
	,   quantity
	,   remarks
	,   price
	,   salesman
	,   customer
	,   vendor
	,   po_number
	,   operator
	,   from_loc
	,   to_loc
	,   on_hand
	,   lot
	,   weight
	,   status
	,   shipper
	,   flag
	,   activity
	,   unit
	,   workorder
	,   std_quantity
	,   cost
	,   control_number
	,   custom1
	,   custom2
	,   custom3
	,   custom4
	,   custom5
	,   plant
	,   invoice_number
	,   notes
	,   gl_account
	,   package_type
	,   suffix
	,   due_date
	,   group_no
	,   sales_order
	,   release_no
	,   dropship_shipper
	,   std_cost
	,   user_defined_status
	,   engineering_level
	,   posted
	,   parent_serial
	,   origin
	,   destination
	,   sequence
	,   object_type
	,   part_name
	,   start_date
	,   field1
	,   field2
	,   show_on_shipper
	,   tare_weight
	,   kanban_number
	,   dimension_qty_string
	,   dim_qty_string_other
	,   varying_dimension_code
	)
	select 
		serial = o.serial
	,   date_stamp = @TranDT
	,   type = 'T'
	,   part = o.part
	,   quantity = o.quantity
	,   remarks = 'Transfer'
	,   price = 0
	,   salesman = ''
	,   customer = ''
	,   vendor = ''
	,   po_number = ''
	,   operator = @Operator
	,   from_loc = @LocationOriginal
	,   to_loc = o.location
	,   on_hand =
			(	select
					sum(o2.std_quantity)
				from
					dbo.object o2
				where
					o2.status = 'A'
					and o2.part = o.part
			)
	,   lot = o.Lot
	,   weight = o.weight
	,   status = o.status
	,   shipper = o.origin
	,   flag = ''
	,   activity = ''
	,   unit = o.unit_measure
	,   workorder = o.workorder
	,   std_quantity = o.std_quantity
	,   cost = o.Cost
	,   control_number = ''
	,   custom1 = o.custom1
	,   custom2 = o.custom2
	,   custom3 = o.custom3
	,   custom4 = o.custom4
	,   custom5 = o.custom5
	,   plant = o.plant
	,   invoice_number = ''
	,   notes = @Notes
	,   gl_account = ''
	,   package_type = o.package_type
	,   suffix = null
	,   due_date = null
	,   group_no = ''
	,   sales_order = ''
	,   release_no = ''
	,   dropship_shipper = 0
	,   std_cost = o.std_cost
	,   user_defined_status = o.user_defined_status
	,   engineering_level = ''
	,   posted = null
	,   parent_serial = o.parent_serial
	,   origin = o.origin
	,   destination = ''
	,   sequence = null
	,   object_type = null
	,   part_name = (select name from part where part = o.part)
	,   start_date = null
	,   field1 = o.field1
	,   field2 = o.field2
	,   show_on_shipper = o.show_on_shipper
	,   tare_weight = null
	,   kanban_number = null
	,   dimension_qty_string = null
	,   dim_qty_string_other = null
	,   varying_dimension_Code = null
	from
		object o
	where
		o.parent_Serial = @PalletSerial

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 100022
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount = 0 begin
		set	@Result = 100023
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, @NumberOfBoxes)
		rollback tran @ProcName
		return
	end
end
--- </Create transfer record for boxes on pallet>
--- </Body>



--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction @ProcName
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	Success.
set	@Result = 0
return
	@Result


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
	@Operator varchar(5) = 'RCR'
,	@Serial int
,	@Location varchar(10)
,	@Notes varchar(254) = null
,	@TranDT datetime out
,	@Result integer out

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_InventoryControl_JobComplete
	@Operator = @Operator
,	@Serial int
,	@Location varchar(10)
,	@Notes varchar(254) = null
,	@TranDT datetime out
,	@Result integer out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	dbo.audit_trail at
where
	at.serial = @Serial

select
	*
from
	dbo.BackflushHeaders bh
where
	bh.SerialProduced = @NewSerial

select
	*
from
	dbo.BackflushDetails bd
where
	bd.BackflushNumber = (select bh.BackflushNumber from dbo.BackflushHeaders bh where bh.SerialProduced = @NewSerial)

select
	*
from
	dbo.audit_trail at
where
	at.serial in
		(	select
				bd.SerialConsumed
			from
				dbo.BackflushDetails bd
			where
				bd.BackflushNumber = (select bh.BackflushNumber from dbo.BackflushHeaders bh where bh.SerialProduced = @NewSerial)
		)
	and at.type = 'M'
	and at.date_stamp = (select bh.TranDT from dbo.BackflushHeaders bh where bh.SerialProduced = @NewSerial)
go

select
	*
from
	FT.SPLogging
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

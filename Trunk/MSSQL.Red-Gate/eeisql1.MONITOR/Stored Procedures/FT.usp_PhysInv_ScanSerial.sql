SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[usp_PhysInv_ScanSerial]
	@Operator varchar(10)
,	@BoxSerial int,
	@Plant varchar(10)
,	@Rack varchar(10)
,	@Shelf varchar(10)
,	@Position varchar(10)
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

---	</ArgumentValidation>

--- <Body>
/*	Update inventory location. */
declare
    @TranType char(1) = 'H'
,   @Remark varchar(10) = 'Phys Scan'
,   @Notes varchar(50) = 'Serial scanned during physical inventory.'

--- <Insert rows="*">
set	@TableName = 'dbo.audit_trail'

insert
	dbo.audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	operator
,	from_loc
,	to_loc
,	parent_serial
,	lot
,	weight
,	status
,	shipper
,	unit
,	std_quantity
,	plant
,	notes
,	package_type
,	std_cost
,	user_defined_status
,	tare_weight
)
select
	o.serial
,	date_stamp = @TranDT
,	type = @TranType
,	o.part
,	o.quantity
,	remarks = @Remark
,	o.operator
,	from_loc = o.location
,	to_loc =
		(	select
				min(pwl.Address)
			from
				FT.PlantWarehouseLocations pwl
			where
				pwl.Plant = @Plant
				and pwl.Rack = @Rack
				and pwl.Shelf = @Shelf
				and pwl.Position = @Position
		)
,	o.parent_serial
,	o.lot
,	o.weight
,	o.status
,	o.shipper
,	unit = o.unit_measure
,	o.std_quantity
,	o.plant
,	@Notes
,	o.package_type
,	std_cost = o.cost
,	o.user_defined_status
,	o.tare_weight
from
	dbo.object o
where
	o.serial = @BoxSerial

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

--- <Update rows="*">
set	@TableName = 'dbo.object'

update
	o
set
	operator = @Operator
,	location =
		(	select
				min(pwl.Address)
			from
				FT.PlantWarehouseLocations pwl
			where
				pwl.Plant = @Plant
				and pwl.Rack = @Rack
				and pwl.Shelf = @Shelf
				and pwl.Position = @Position
		)
,	last_date = @TranDT
,	last_time = @TranDT
from
	dbo.object o
where
	o.serial = @BoxSerial

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
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.usp_PhysInv_ScanSerial
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

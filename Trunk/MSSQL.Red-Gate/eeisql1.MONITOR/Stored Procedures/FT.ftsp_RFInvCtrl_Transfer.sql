SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_RFInvCtrl_Transfer]
    @Operator varchar(10)
,	@Serial integer
,	@NewLocationCode varchar(10)
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
/*	Update the object(s) location. */
declare @ObjectLocation varchar(10)

select
    @ObjectLocation = min(location)
from
    object
where
    serial = @Serial
    or parent_serial = @Serial

--- <Update rows="1+">
set	@TableName = 'dbo.object'

update
    o
set
    operator = @Operator
,	location = l.code
,	plant = l.plant
,	last_date = getdate()
from
	dbo.object o
	join dbo.location l
		on l.code = @NewLocationCode
where
    o.serial = @Serial
    or o.parent_serial = @Serial

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <= 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>

/*	Insert audit trail. */
declare
    @TranType char(1)
,   @Remark varchar(10)
,   @Notes varchar(50)

set @TranType = 'T'
set @Remark = 'Transfer'
set @Notes = 'Serial traferred by RF Inventory Control.'

--- <Insert rows="1+">
set	@TableName = 'dbo.audit_trail'

insert
	dbo.audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	vendor
,	po_number
,	operator
,	from_loc
,	to_loc
,	on_hand
,	parent_serial
,	lot
,	weight
,	status
,	shipper
,	unit
,	std_quantity
,	cost
,	plant
,	notes
,	package_type
,	std_cost
,	user_defined_status
,	tare_weight
)
select
	object.serial
,	object.last_date
,	@TranType
,	object.part
,	object.quantity
,	@Remark
,	(	select
			vendor_code
        from
	        po_header
        where
		    po_number = object.po_number
    )
,	object.po_number
,	object.operator
,	@ObjectLocation
,	object.location
,	(	select
	        on_hand
        from
		    part_online
        where
			part = object.part
    )
,	object.parent_serial
,	object.lot
,	object.weight
,	object.status
,	object.shipper
,	object.unit_measure
,	object.std_quantity
,	object.cost
,	object.plant
,	@Notes
,	object.package_type
,	object.cost
,	object.user_defined_status
,	object.tare_weight
from
    object object
where
    object.serial = @Serial
    or object.parent_serial = @Serial

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <= 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>
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
	@ProcReturn = FT.ftsp_RFInvCtrl_Transfer
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

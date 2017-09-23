SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [HN].[SP_TransferPlantRack]
	@Operator varchar(10)
,	@RackPlant varchar(5)
,	@Type varchar(20)
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

	declare @toloc varchar(10)
	set @toloc=''
	declare @TranDT datetime
	set @TranDT =Getdate()
set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FT.usp_Test
--- </Error Handling>


declare @location table(code varchar(10))

		if @Type='Plant' begin 
			insert into @location(code)
			select code from hn.vw_Picklist_LocationValid where plant=@RackPlant
		end
		else Begin 
			insert into @location(code)
			select distinct code  from location where  convert( varchar (10), Substring (location.code, 3, 1))=@RackPlant
			and	(	location.code like '[A-Z]-[1234]-[0-9]' or
		location.code like '[A-Z]-[1234]-[0-9][0-9]')
		end


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
    @TranType char(1) = 'G'
,   @Remark varchar(10) = 'Begin Phys'
,   @Notes varchar(50) = '.'

--- <Insert rows="*">
set	@TableName = 'Begin a physical inventory.'

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
,	to_loc =@toloc
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
where o.location in (select code from @location)



	
	
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


update
	o
set
	operator = @Operator
,	location =@toloc
,	last_date = @TranDT
,	last_time = @TranDT
from
	dbo.object o
where
	o.location in (select code from @location)
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

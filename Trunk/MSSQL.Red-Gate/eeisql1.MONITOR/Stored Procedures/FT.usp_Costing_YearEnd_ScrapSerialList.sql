SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[usp_Costing_YearEnd_ScrapSerialList]
	@Operator varchar(5)
,	@SerialCSVFile_ServerPath sysname --i.e. c:\Temp\SerialList.CSV
,	@EffectiveDT datetime --i.e. 2014-03-31 23:00
,	@Mode int = 0 --0 test, 1 commit
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings on
set ansi_nulls on
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
create table
	#SerialList
(	Serial int
,	IsDuplicate bit default (0)
,	IsExisting bit default (0)
,	ActionMessage varchar(max)
,	RowID int not null IDENTITY(1, 1) primary key
)

declare
	@ReadCSVFileSyntax nvarchar(max) = '
select
	*
from
	openrowset(''MSDASQL''
               ,''Driver={Microsoft Access Text Driver (*.txt, *.csv)}''
               ,''select * from ' + @SerialCSVFile_ServerPath + ''')
'

--- <Call>	
set	@CallProcName = 'sp_executesql'

insert
	#SerialList
(	Serial
)
execute
	@ProcReturn = sp_executesql
		@stmt = @ReadCSVFileSyntax

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName

	print @ReadCSVFileSyntax
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>

--- <Update rows="*">
set	@TableName = '#SerialList'

update
	sl
set
	IsExisting = 1
from
	#SerialList sl
where
	exists
		(	select
				*
			from
				dbo.object o
			where
				o.serial = sl.Serial
		)

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

--- <Update rows="*">
set	@TableName = '#SerialList'

update
	sl
set
	IsDuplicate = 1
from
	#SerialList sl
where
	exists
		(	select
				*
			from
				#SerialList sl2
			where
				sl2.Serial = sl.Serial
				and sl2.RowID < sl.RowID
		)

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

--- <Update rows="*">
set	@TableName = '#SerialList'

update
	sl
set
	ActionMessage =
		case
			when sl.IsDuplicate = 1 then 'Duplicate, ignoring.'
			when sl.IsExisting = 0 then 'Serial doesn''t exist, ignoring.'
			else 'Scrap effective ' + convert(varchar, @EffectiveDT, 101) + ' and remove from object historical and object historical daily after effective date.'
		end
from
	#SerialList sl

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

if	@Mode = 1 begin
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
	,	price
	,	salesman
	,	customer
	,	vendor
	,	po_number
	,	operator
	,	from_loc
	,	to_loc
	,	on_hand
	,	lot
	,	weight
	,	status
	,	shipper
	,	flag
	,	activity
	,	unit
	,	workorder
	,	std_quantity
	,	cost
	,	control_number
	,	custom1
	,	custom2
	,	custom3
	,	custom4
	,	custom5
	,	plant
	,	invoice_number
	,	notes
	,	gl_account
	,	package_type
	,	suffix
	,	due_date
	,	group_no
	,	sales_order
	,	release_no
	,	dropship_shipper
	,	std_cost
	,	user_defined_status
	,	engineering_level
	,	posted
	,	parent_serial
	,	origin
	,	destination
	,	sequence
	,	object_type
	,	part_name
	,	start_date
	,	field1
	,	field2
	,	show_on_shipper
	,	tare_weight
	,	kanban_number
	,	dimension_qty_string
	,	dim_qty_string_other
	,	varying_dimension_code
	,	invoice
	,	invoice_line
	)
	select
		serial = o.serial
	,	date_stamp = @EffectiveDT
	,	type = 'Q'
	,	part = o.part
	,	quantity = o.quantity
	,	remarks = 'Quality'
	,	price = 0
	,	salesman = ''
	,	customer = ''
	,	vendor = ''
	,	po_number = o.po_number
	,	operator = @Operator
	,	from_loc = 'A'
	,	to_loc = 'S'
	,	on_hand = 0
	,	lot = o.lot
	,	weight = o.weight
	,	status = 'S'
	,	shipper = o.shipper
	,	flag = ''
	,	activity = ''
	,	unit = o.unit_measure
	,	workorder = o.workorder
	,	std_quantity = o.std_quantity
	,	cost = o.cost
	,	control_number = ''
	,	custom1 = o.custom1
	,	custom2 = o.custom2
	,	custom3 = o.custom3
	,	custom4 = o.custom4
	,	custom5 = o.custom5
	,	plant = o.plant
	,	invoice_number = ''
	,	notes = ''
	,	gl_account = '11'
	,	package_type = o.package_type
	,	suffix = o.suffix
	,	due_date = null
	,	group_no = ''
	,	sales_order = ''
	,	release_no = ''
	,	dropship_shipper = null
	,	std_cost = o.std_cost
	,	user_defined_status = 'Scrapped'
	,	engineering_level = o.engineering_level
	,	posted = o.posted
	,	parent_serial= o.parent_serial
	,	origin = o.origin
	,	destination = o.destination
	,	sequence = o.sequence
	,	object_type = o.type
	,	part_name = p.name
	,	start_date = null
	,	field1 = o.field1
	,	field2 = o.field2
	,	show_on_shipper= o.show_on_shipper
	,	tare_weight = o.tare_weight
	,	kanban_number= o.kanban_number
	,	dimension_qty_string = o.dimension_qty_string
	,	dim_qty_string_other = o.dim_qty_string_other
	,	varying_dimension_code = o.varying_dimension_code
	,	invoice = ''
	,	invoice_line = ''
	from
		dbo.object o
		left join dbo.part p
			on p.part = o.part
	where
		o.serial in
			(	select distinct
					Serial
				from
					#SerialList sl
				where
					sl.IsDuplicate = 0
					and sl.IsExisting = 1
			)

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
	,	price
	,	salesman
	,	customer
	,	vendor
	,	po_number
	,	operator
	,	from_loc
	,	to_loc
	,	on_hand
	,	lot
	,	weight
	,	status
	,	shipper
	,	flag
	,	activity
	,	unit
	,	workorder
	,	std_quantity
	,	cost
	,	control_number
	,	custom1
	,	custom2
	,	custom3
	,	custom4
	,	custom5
	,	plant
	,	invoice_number
	,	notes
	,	gl_account
	,	package_type
	,	suffix
	,	due_date
	,	group_no
	,	sales_order
	,	release_no
	,	dropship_shipper
	,	std_cost
	,	user_defined_status
	,	engineering_level
	,	posted
	,	parent_serial
	,	origin
	,	destination
	,	sequence
	,	object_type
	,	part_name
	,	start_date
	,	field1
	,	field2
	,	show_on_shipper
	,	tare_weight
	,	kanban_number
	,	dimension_qty_string
	,	dim_qty_string_other
	,	varying_dimension_code
	,	invoice
	,	invoice_line
	)
	select
		serial = o.serial
	,	date_stamp = dateadd(second, 1, @EffectiveDT)
	,	type = 'D'
	,	part = o.part
	,	quantity = 0
	,	remarks = 'Delete'
	,	price = 0
	,	salesman = ''
	,	customer = ''
	,	vendor = ''
	,	po_number = o.po_number
	,	operator = @Operator
	,	from_loc = o.location
	,	to_loc = 'TRASH'
	,	on_hand = 0
	,	lot = o.lot
	,	weight = o.weight
	,	status = 'S'
	,	shipper = o.shipper
	,	flag = ''
	,	activity = ''
	,	unit = o.unit_measure
	,	workorder = o.workorder
	,	std_quantity = 0
	,	cost = o.cost
	,	control_number = ''
	,	custom1 = o.custom1
	,	custom2 = o.custom2
	,	custom3 = o.custom3
	,	custom4 = o.custom4
	,	custom5 = o.custom5
	,	plant = o.plant
	,	invoice_number = ''
	,	notes = ''
	,	gl_account = '11'
	,	package_type = o.package_type
	,	suffix = o.suffix
	,	due_date = null
	,	group_no = ''
	,	sales_order = ''
	,	release_no = ''
	,	dropship_shipper = null
	,	std_cost = o.std_cost
	,	user_defined_status = 'Scrapped'
	,	engineering_level = o.engineering_level
	,	posted = o.posted
	,	parent_serial= o.parent_serial
	,	origin = o.origin
	,	destination = o.destination
	,	sequence = o.sequence
	,	object_type = o.type
	,	part_name = p.name
	,	start_date = null
	,	field1 = o.field1
	,	field2 = o.field2
	,	show_on_shipper= o.show_on_shipper
	,	tare_weight = o.tare_weight
	,	kanban_number= o.kanban_number
	,	dimension_qty_string = o.dimension_qty_string
	,	dim_qty_string_other = o.dim_qty_string_other
	,	varying_dimension_code = o.varying_dimension_code
	,	invoice = ''
	,	invoice_line = ''
	from
		dbo.object o
		left join dbo.part p
			on p.part = o.part
	where
		o.serial in
			(	select distinct
					Serial
				from
					#SerialList sl
				where
					sl.IsDuplicate = 0
					and sl.IsExisting = 1
			)

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

	--- <Delete rows="*">
	set	@TableName = 'dbo.object'
	
	delete
		o
	from
		dbo.object o
	where
		o.serial in
			(	select distinct
					Serial
				from
					#SerialList sl
				where
					sl.IsDuplicate = 0
					and sl.IsExisting = 1
			)	
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Delete>
	
	--- <Delete rows="*">
	set	@TableName = 'dbo.object_historical'
	
	delete
		oh
	from
		dbo.object_historical oh
	where
		oh.time_stamp > @EffectiveDT
		and	oh.serial in
			(	select distinct
					Serial
				from
					#SerialList sl
				where
					sl.IsDuplicate = 0
					and sl.IsExisting = 1
			)	
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Delete>

	--- <Delete rows="*">
	set	@TableName = 'dbo.object_historical_daily'
	
	delete
		ohd
	from
		dbo.object_historical_daily ohd
	where
		ohd.time_stamp > @EffectiveDT
		and	ohd.serial in
			(	select distinct
					Serial
				from
					#SerialList sl
				where
					sl.IsDuplicate = 0
					and sl.IsExisting = 1
			)	
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Delete>
end
--- </Body>

--- <ResultSet>
select
	*
from
	#SerialList sl
--- </ResultSet>

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
	@ProcReturn = FT.usp_Costing_YearEnd_ScrapSerialList
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

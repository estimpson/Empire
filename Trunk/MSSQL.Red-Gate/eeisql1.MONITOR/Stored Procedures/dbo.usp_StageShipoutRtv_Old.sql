SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[usp_StageShipoutRtv_Old]
	@OperatorCode varchar(5)
,	@RmaShipper integer
,	@RtvShipper integer
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
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
declare	
	@DateStamp datetime
,	@RmaNotes varchar(255)
,	@RtvNotes varchar(255)

select
	@DateStamp = getdate()	
select		
	@RmaNotes = 'Received from RMA: ' + convert(varchar(50), @RmaShipper)
select		
	@RtvNotes = 'Auto RTV : Created via SQL Script'


-- Insure all RMA serials exist in the object table
-- 
declare @temp table
(
	SerialNumber int not null
,	Verified int not null
)

insert @temp 
(
	SerialNumber
,	Verified
)
select
	at.serial
,	0
from
	dbo.audit_trail at
where	
	at.shipper = convert(varchar(50), @RmaShipper)
	and at.type = 'U'

declare
	@Serial int = 0
	
select
	@Serial = min(SerialNumber)
from
	@temp
where
	Verified = 0


while ((select count(1) from @temp where Verified = 0) > 0) begin

	if not exists
	(	select
			1
		from
			dbo.object o
		where
			o.serial = @Serial) begin
			
			
		-- Make sure a po number is added to the object
		declare
			@PartNumber varchar(25)
		,	@PoNumber varchar(30)
		
		select
			@PartNumber = at.part
		,	@PoNumber = coalesce(at.po_number, '')
		from
			dbo.audit_trail at
		where
			at.serial = @Serial
			and at.shipper = convert(varchar(50), @RmaShipper)
			and at.type = 'U'	
			
		if (@PoNumber = '') begin
			
			-- No PO in the audit_trail for this serial/part, so search the po_header table for one
			if not exists
				(	select
						1
					from
						dbo.po_header ph
					where
						ph.blanket_part = @PartNumber ) begin
			
				set	@Result = 999999
				RAISERROR ('No purchase order exists for part %s.  Cannot return to vendor.  Make sure it is a part that can be sent to Honduras.  Procedure %s.', 16, 1, @PartNumber, @ProcName)
				rollback tran @ProcName
				return
			end
			else begin
				select
					@PoNumber = max(ph.po_number)
				from
					dbo.po_header ph
				where
					ph.blanket_part = @PartNumber
			end
		
		end
			
				                    	
		--- <Insert rows="0+">
		set	@TableName = 'dbo.object'	

		insert dbo.object
		(
			serial
		,	part
		,	location
		,	last_date
		,	unit_measure
		,	operator
		,	status
		,	destination
		,	station
		,	origin
		,	cost
		,	weight
		,	parent_serial
		,	note
		,	quantity
		,	last_time
		,	date_due
		,	customer
		,	sequence
		,	shipper
		,	lot
		,	type
		,	po_number
		,	name
		,	plant
		,	start_date
		,	std_quantity
		,	package_type
		,	field1
		,	field2
		,	custom1
		,	custom2
		,	custom3
		,	custom4
		,	custom5
		,	show_on_shipper
		,	tare_weight
		,	suffix
		,	std_cost
		,	user_defined_status
		,	workorder
		,	engineering_level
		,	kanban_number
		,	dimension_qty_string
		,	dim_qty_string_other
		,	varying_dimension_code
		,	posted
		)
		select
			serial = at.serial
		,	part = at.part
		,	location = at.to_loc
		,	last_date = at.date_stamp
		,	unit_measure = at.unit
		,	operator = at.operator
		,	status = at.status
		,	destination = at.destination
		,	station = ''
		,	origin = at.origin
		,	cost = at.cost
		,	weight = at.weight
		,	parent_serial = at.parent_serial
		,	note = @RmaNotes
		,	quantity = at.quantity
		,	last_time = null
		,	date_due = null
		,	customer = at.customer
		,	sequence = null
		,	shipper = @RtvShipper
		,	lot = at.lot
		,	type = null
		,	po_number = @PoNumber
		,	name = null
		,	plant = at.plant
		,	start_date = null
		,	std_quantity = at.std_quantity
		,	package_type = at.package_type
		,	field1 = at.field1
		,	field2 = at.field2
		,	custom1 = at.custom1
		,	custom2 = at.custom2
		,	custom3 = at.custom3
		,	custom4 = at.custom4
		,	custom5 = at.custom5
		,	show_on_shipper = 'Y'
		,	tare_weight = at.tare_weight
		,	suffix = at.suffix
		,	std_cost = at.std_cost
		,	user_defined_status = at.user_defined_status
		,	workorder = at.workorder
		,	engineering_level = at.engineering_level
		,	kanban_number = at.kanban_number
		,	dimension_qty_string = null
		,	dim_qty_string_other = null
		,	varying_dimension_code = null
		,	posted = at.posted
		from 
			dbo.audit_trail at
		where
			at.serial = @Serial
			and at.shipper = convert(varchar(50), @RmaShipper)
			and at.type = 'U'		                    	
	
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
	end
	
	update 
		@temp 
	set 
		Verified = 1 
	where 
		SerialNumber = @Serial
	
	select
		@Serial = min(SerialNumber)
	from
		@temp
	where
		Verified = 0
end


/*
-- Create records of the serials to be shipped out on the RTV shipper
--
--- <Insert rows="1+">
set	@TableName = 'dbo.audit_trail'			
			
insert dbo.audit_trail
(
	serial
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
,	dbdate
)
select 
	serial
,	date_stamp
,	type = 'V'
,	part
,	quantity
,	remarks = 'Ret Vendor'
,	price
,	salesman = ''
,	customer = 'EMPHOND'
,	vendor = ''
,	po_number = null
,	operator = @OperatorCode
,	from_loc
,	to_loc = 'EMPHOND'
,	on_hand
,	lot = ''
,	weight = 0
,	status = 'A'
,	shipper = convert(varchar(50), @RtvShipper)
,	flag = ''
,	activity = ''
,	unit = 'EA'
,	workorder = null
,	std_quantity = quantity
,	cost
,	control_number = ''
,	custom1 = ''
,	custom2 = ''
,	custom3 = ''
,	custom4 = ''
,	custom5 = ''
,	plant
,	invoice_number = null
,	notes = @RtvNotes
,	gl_account = '11'
,	package_type = ''
,	suffix = null
,	due_date = null
,	group_no = null
,	sales_order = null
,	release_no = null
,	dropship_shipper = null
,	std_cost
,	user_defined_status = 'Approved'
,	engineering_level = null
,	posted = 'N'
,	parent_serial = null
,	origin = convert(varchar(50), @RtvShipper)
,	destination = 'EmpHond'
,	sequence = null
,	object_type = null
,	part_name = null
,	start_date = null
,	field1 = null
,	field2 = null
,	show_on_shipper = 'Y'
,	tare_weight = null
,	kanban_number = null
,	dimension_qty_string = null
,	dim_qty_string_other = null
,	varying_dimension_code = null
,	invoice = null
,	invoice_line = null
,	dbdate = @DateStamp
from 
	dbo.audit_trail at
where
	at.shipper = @RmaShipper
	and at.type = 'U'	

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount = 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: >0.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>	
*/
	 
	 


-- Make sure any serials that were not created automatically have a po number
--
declare @tempParts table
(
	Part varchar(25)
,	Po varchar(30)
,	Verified int
)

insert @tempParts
(
	Part
,	Po
,	Verified
)
select
	o.part
,	coalesce(max(o.po_number), '')
,	0
from
	dbo.object o
where 
	shipper = @RmaShipper
group by
	o.part
	
	
declare
	@ObjectPart varchar(25)
,	@ObjectPo varchar(30)
,	@Po varchar(30)	
	
select
	@ObjectPart = min(Part)
from
	@tempParts
where
	Verified = 0
	
select
	@ObjectPo = Po
from
	@tempParts
where
	Part = @ObjectPart
	

while ((select count(1) from @tempParts where Verified = 0) > 0) begin
	
	if (@ObjectPo = '') begin

		-- No PO for this serial/part, so search the po_header table for one
		if not exists
			(	select
					1
				from
					dbo.po_header ph
				where
					ph.blanket_part = @ObjectPart ) begin
		
			set	@Result = 999999
			RAISERROR ('No purchase order exists for part %s.  Cannot return to vendor.  Make sure it is a part that can be sent to Honduras.  Procedure %s.', 16, 1, @ObjectPart, @ProcName)
			rollback tran @ProcName
			return
		end
		else begin
			select
				@Po = max(ph.po_number)
			from
				dbo.object o
				join dbo.po_header ph
					on ph.blanket_part = o.part
			where
				o.part = @ObjectPart
				
			--- <Update>
			set	@TableName = 'dbo.object'

			update
				dbo.object
			set
				po_number = @Po
			where
				part = @ObjectPart
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
				
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s with PO number in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			--- </Update>
		end

	end
	
	update 
		@tempParts
	set 
		Verified = 1 
	where 
		Part = @ObjectPart
	
	select
		@ObjectPart = min(Part)
	from
		@tempParts
	where
		Verified = 0
		
	select
		@ObjectPo = Po
	from
		@tempParts
	where
		Part = @ObjectPart

end
	
	


-- Any serials that were not created automatically need to be updated with the RTV shipper
--
--- <Update>
set	@TableName = 'dbo.object'

update 
	dbo.object 
set 
	shipper = @RtvShipper, 
	show_on_shipper = 'Y'
where 
	shipper = @RmaShipper

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s with RTV shipper in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>



-- Update the RTV shipper as staged
--
--- <Update rows="1">
set	@TableName = 'dbo.shipper'

update 
	dbo.shipper
set 
	status = 'S'
where 
	id = @RtvShipper

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <> 1 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>



-- Ship out the RTV
--
--- <Call>	
set	@CallProcName = 'dbo.msp_shipout'
execute @ProcReturn = dbo.msp_shipout
	@RtvShipper
,	@DateStamp

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	raiserror ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	raiserror ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return
end
---</Call>
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
GO

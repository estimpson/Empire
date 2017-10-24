SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[usp_CreateRma_ProcessSerialsQuantities_ByDestGl_Ala]
	@OperatorCode varchar(5)
,	@Destination varchar(20)
,	@GlSegment varchar(20)
,	@RmaNumber varchar(50)
,	@CreateRTV int = 0
,	@PlaceSerialsOnHold int = 0
,	@NextShipper integer = null out
,	@NextShipperRTV integer = null out
,	@Notes varchar(200)
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
select 
	@NextShipper = shipper 
from 
	dbo.parameters
	

--- <Update rows="1">
set	@TableName = 'dbo.parameters'

update 
	dbo.parameters 
set 
	shipper = shipper + 1

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
	RAISERROR ('Error updating table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>	
	
	

declare	
	@DateStamp datetime
,	@RmaNotes varchar(255)

select
	@DateStamp = getdate()	
select 
	@RmaNotes = @RmaNumber + '  ' + @Notes


select			
	at.serial,
	@DateStamp dateStamp,
	'U' attype,
	at.part,
	srma.quantity,
	'RMA' Remarks,
	(Select MAX(alternate_price) from shipper_detail sd where convert(varchar(25), sd.shipper) =  at.shipper and part_original = at.part ) as price,
	customer,
	@OperatorCode operator,
	to_loc fromLoc,
	isNULL((Select min(location.code) from location where code like '%RMA%' and code  like '%EEI%'), 'EEI') as toLoc,
	(Select sum(quantity) from object where object.part = at.part and status = 'A') as onHand ,
	weight,
	'A' Status,
	convert(varchar(25), @NextShipper) shipper,
	origin,
	std_quantity,
	part_standard.material_cum,					
	plant,
	@RmaNotes note,
	gl_account,
	user_defined_status,
	posted,
	parent_serial,
	destination,
	sd.part_name PartName,
	sd.customer_part CustomerPart,
	sd.price  SdPrice,
	--(Select MAX(shipper) from audit_trail at2 where  at2.part = at.part and at2.type = 'S' and at2.shipper >= at.shipper) as sdshipper
	at.shipper sdshipper,
	at.po_number
into  
	#SerialRma_Original
from 
	dbo.SerialsQuantitiesToAutoRMA_RTV srma
	left join dbo.audit_trail at 
		on at.serial = srma.serial 
		and at.type = 'S' 
		and at.date_stamp = (	select max(date_stamp) 
								from audit_trail at2 
								where at2.type = 'S' and at2.serial = srma.serial )
		and at.destination = @Destination
	join dbo.part_standard 
		on part_standard.part = at.part
	join dbo.shipper_detail sd 
		on convert(varchar(25), sd.shipper) = at.shipper 
		and sd.part_original = at.part


-- Filter by gl_segment
select			
	serial,
	dateStamp,
	attype,
	sro.part,
	quantity,
	Remarks,
	price,
	customer,
	operator,
	fromLoc,
	toLoc,
	onHand,
	weight,
	Status,
	shipper,
	origin,
	std_quantity,
	material_cum,					
	plant,
	note,
	gl_account,
	user_defined_status,
	posted,
	parent_serial,
	destination,
	PartName,
	CustomerPart,
	SdPrice,
	--sdshipper
	sdshipper,
	po_number
into  
	#SerialRma
from
	#SerialRma_Original sro
	join eehsql1.eeh.dbo.part p
		on p.part = sro.part
	join eehsql1.eeh.dbo.product_line pl
		on p.product_line = pl.id
where
	pl.gl_segment = @GlSegment
	



--- <Insert rows="1">
set	@TableName = 'dbo.shipper'
	
insert dbo.shipper
( 
	id,
	destination,
	status,
	customer,
	type,
	date_stamp,
	cs_status,
	operator
)
select	
	@NextShipper,
	destination,
	'O',
	customer,
	'R',
	@DateStamp,
	'Approved',
	@OperatorCode
from 
	#SerialRma
group by 
	destination, 
	customer

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
	
	
--- <Insert rows="1+">
set	@TableName = 'dbo.shipper_detail'

insert dbo.shipper_detail
(	
	shipper,
	part,
	qty_required,
	qty_packed,
	qty_original,
	accum_shipped,
	order_no,
	type,
	price,
	account_code,
	operator,
	boxes_staged,
	alternative_qty,
	alternative_unit,
	price_type,
	customer_part,
	suffix,
	part_name,
	part_original,
	stage_using_weight,
	alternate_price,
	old_suffix,
	old_shipper
)
select  
	@NextShipper,
	SRMA.part + '-1',
	sum(SRMA.quantity) * -1,
	sum(SRMA.quantity) * -1,
	sum(SRMA.quantity) * -1,
	0,
	(select max(order_no) from order_header where shipper = ( select max(shipper) from #SerialRma) and blanket_part = SRMA.part),
	'I',
	min(price),
	min(peec.sales_return_account),
	@OperatorCode,
	count(1),
	sum(SRMA.quantity) * -1,
	'EA',
	'P',
	max(CustomerPart),
	0,
	max(PartName),
	SRMA.Part,
	'N',
	min(SdPrice),
	0,
	max(sdShipper)
from 
	#SerialRma SRMA
	--join part_eecustom peec 
	--	on peec.part =  SRMA.part
	join EEHSQL1.EEH.dbo.part_eecustom peec
		on peec.part = SRMA.part
group by 
	SRMA.part
	
			
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
			
		
			
declare
	@Status char(1)
,	@UserDefinedStatus varchar(25)

if (@PlaceSerialsOnHold = 1) begin
	select @Status = 'H'
	select @UserDefinedStatus = 'On Hold'
end 
else begin
	select @Status = 'A'
	select @UserDefinedStatus = 'Approved'
end
			

--- <Insert rows="1+">
set	@TableName = 'dbo.audit_trail'			
			
insert dbo.audit_trail
(
	serial
	,date_stamp
	,type
	,part
	,quantity
	,remarks
	,price
	,salesman
	,customer
	,vendor
	,po_number
	,operator
	,from_loc
	,to_loc
	,on_hand
	,lot
	,weight
	,status
	,shipper
	,flag
	,activity
	,unit
	,workorder
	,std_quantity
	,cost
	,control_number
	,custom1
	,custom2
	,custom3
	,custom4
	,custom5
	,plant
	,invoice_number
	,notes
	,gl_account
	,package_type
	,suffix
	,due_date
	,group_no
	,sales_order
	,release_no
	,dropship_shipper
	,std_cost
	,user_defined_status
	,engineering_level
	,posted
	,parent_serial
	,origin
	,destination
	,sequence
	,object_type
	,part_name
	,start_date
	,field1
	,field2
	,show_on_shipper
	,tare_weight
	,kanban_number
	,dimension_qty_string
	,dim_qty_string_other
	,varying_dimension_code
	,invoice
	,invoice_line
	,dbdate
)
select 
	serial
	,@DateStamp
	,'U'
	,part
	,quantity
	,remarks
	,price
	,''
	,customer
	,''
	,po_number
	,@OperatorCode
	,fromLoc
	,'QC-1'
	,onHand
	,''
	,0
	,@Status
	,@NextShipper
	,''
	,''
	,'EA'
	,null
	,quantity
	,material_cum
	,''
	,''
	,''
	,''
	,''
	,''
	,plant
	,null
	,@RmaNotes
	,gl_account
	,''
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,material_cum
	,@UserDefinedStatus
	,NULL
	,'N'
	,NULL
	,@NextShipper
	,fromLoc
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,'N'
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,@DateStamp
from 
	#SerialRma SRMA

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

--insert object
Insert	object 
	(	serial,
		last_date,
		last_time,
		type,
		part,
		quantity,
		std_quantity,
		unit_measure,
		note,
		operator,
		location,
		Status,
		destination,
		origin,
		cost,
		std_cost,
		parent_serial,
		plant,
		user_defined_status,
		po_number
	)
Select	serial,
		getdate(),
		getdate(),
		NULL,
		SRMA.part ,
		SRMA.quantity,
		SRMA.quantity,
		'EA',
		'Auto RTV',
		operator,
		SRMA.toLoc,
		@Status,
		destination,
		shipper,
		SRMA.material_cum,
		SRMA.material_cum,
		parent_serial,
		SRMA.plant,
		@UserDefinedStatus,
		SRMA.po_number
	
From	#SerialRma SRMA


select	@Error = @@Error,
		@RowCount = @@Rowcount

if	@Error != 0  or @RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR ('Failed to create new object records in the Troy database.', 16, 1)
	rollback tran @ProcName
	return	@Result
end






/*  If Alabama part, then extra processing is required.  */

-- 'U'	- RMA finished part (already created)
-- 'W1'	- RTV finished part to Honduras
-- 'W2'	- RMA harness
-- 'V'  - RTV harness (staged to shipper here, audit_trail record created at time of ship out)
-- 'U'  - Honduras RMA of harness (created at time of ship out) 

declare @tempPartsList table
(
	Part varchar(25)
,	QuantityReturned numeric(20,6)
,	Processed int
)

declare @tempBulbPartsList table
(
	BulbPart varchar(25)
,	StdQuantity numeric(20,6)
,	Processed int
)

declare @tempSerialsList table
(
	Serial int
,	Processed int
)

insert into	@tempPartsList
(
	Part
,	QuantityReturned
,	Processed
)
select
	srma.part
,	sum(srma.quantity)
,	0
from 
	#SerialRma srma
group by 
	srma.part
	

declare
	@AlabamaPart varchar(25)
,	@AlabamaPartQuantity numeric(20,6)
,	@AlabamaSerial int
,	@HarnessPartNumber varchar(25)
,	@HarnessStdQuantity numeric(20,6)
,	@HarnessCustomerPartNumber varchar(25)
,	@HarnessPartName varchar(50)
	
while ((select count(1) from @tempPartsList where Processed = 0) > 0) begin
	
	select
		@AlabamaPart = min(pl.Part)
	from
		@tempPartsList pl
	where
		pl.Processed = 0
		
	select
		@AlabamaPartQuantity = pl.QuantityReturned
	from
		@tempPartsList pl
	where
		pl.Part = @AlabamaPart

	if (charindex('-A', @AlabamaPart) > 0 and @CreateRTV = 1) begin -- part is an Alabama part and its harness will be returned to Honduras

		-- Alabama part must have a BOM
		if not exists (
				select
					1
				from
					FT.BOM b
				where
					b.ParentPart = @AlabamaPart ) begin
			
			set	@Result = 999999
			RAISERROR ('Alabama part %s does not have a BOM.', 16, 1, @AlabamaPart)
			rollback tran @ProcName
			return	@Result
		end 
	
	
		-- Get the harness child part number from the BOM of this finished part, as well as customer part and part name
		select
			@HarnessPartNumber = bom.ChildPart
		,	@HarnessStdQuantity = bom.StdQty
		from
			FT.BOM bom
		where
			bom.ParentPart = @AlabamaPart
			and bom.ChildPart like substring(@AlabamaPart, 0, charindex('-', @AlabamaPart) ) + '%'
			
		select
			@HarnessCustomerPartNumber = max(oh.customer_part)
		from
			dbo.order_header oh
		where
			oh.blanket_part = @HarnessPartNumber
			
		select
			@HarnessPartName = p.name
		from
			dbo.part p
		where
			p.part = @HarnessPartNumber
			
			
		-- Get the bulb child part number(s) from the BOM of this finished part (for later use)
		insert into @tempBulbPartsList 
		(
			BulbPart
		,	StdQuantity
		,	Processed
		)
		select
			bom.ChildPart
		,	bom.StdQty
		,	0
		from
			FT.BOM bom
		where
			bom.ParentPart = @AlabamaPart
			and bom.ChildPart <> @HarnessPartNumber


		-- Get a list of serials for each Alabama part that is getting RMA / RTV'd.
		insert into	@tempSerialsList
		(
			Serial
		,	Processed
		)
		select
			srma.serial
		,	0
		from 
			#SerialRma srma
		where
			srma.part = @AlabamaPart
			
			
		while ((select count(1) from @tempSerialsList where Processed = 0) > 0) begin
		
			select
				@AlabamaSerial = min(sl.Serial)
			from
				@tempSerialsList sl
			where
				sl.Processed = 0
	
			-- Create a special RTV record (W1) for the finished good part.
			--- <Insert rows="1+">
			set	@TableName = 'dbo.audit_trail'			
						
			insert dbo.audit_trail
			(
				 serial
				,date_stamp
				,type
				,part
				,quantity
				,remarks
				,price
				,salesman
				,customer
				,vendor
				,po_number
				,operator
				,from_loc
				,to_loc
				,on_hand
				,lot
				,weight
				,status
				,shipper
				,flag
				,activity
				,unit
				,workorder
				,std_quantity
				,cost
				,control_number
				,custom1
				,custom2
				,custom3
				,custom4
				,custom5
				,plant
				,invoice_number
				,notes
				,gl_account
				,package_type
				,suffix
				,due_date
				,group_no
				,sales_order
				,release_no
				,dropship_shipper
				,std_cost
				,user_defined_status
				,engineering_level
				,posted
				,parent_serial
				,origin
				,destination
				,sequence
				,object_type
				,part_name
				,start_date
				,field1
				,field2
				,show_on_shipper
				,tare_weight
				,kanban_number
				,dimension_qty_string
				,dim_qty_string_other
				,varying_dimension_code
				,invoice
				,invoice_line
				,dbdate
			)
			select 
				 serial
				,@DateStamp
				,'W1'
				,part
				,quantity
				,'Ret Vendor'
				,price
				,''
				,'EMPHOND'
				,'EEH'
				,po_number
				,@OperatorCode
				,'EEI RMA'
				,'EMPHOND'
				,onHand
				,''
				,0
				,@Status
				,@NextShipper
				,''
				,''
				,'EA'
				,null
				,quantity
				,material_cum
				,''
				,''
				,''
				,''
				,''
				,''
				,plant
				,null
				,'RTV record of Alabama finished part.  Offset for RMA ' + convert(varchar(20), @NextShipper) + '.'
				,gl_account
				,''
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,material_cum
				,@UserDefinedStatus
				,NULL
				,'N'
				,NULL
				,@NextShipper
				,'EMPHOND'
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,'N'
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,@DateStamp
			from 
				#SerialRma srma
			where
				srma.serial = @AlabamaSerial

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
			
			
			
			-- Create a special RMA record (W2) using the finished good part RMA data, but changing its part number to the harness child part.
			--- <Insert rows="1+">
			set	@TableName = 'dbo.audit_trail'			
						
			insert dbo.audit_trail
			(
				 serial
				,date_stamp
				,type
				,part
				,quantity
				,remarks
				,price
				,salesman
				,customer
				,vendor
				,po_number
				,operator
				,from_loc
				,to_loc
				,on_hand
				,lot
				,weight
				,status
				,shipper
				,flag
				,activity
				,unit
				,workorder
				,std_quantity
				,cost
				,control_number
				,custom1
				,custom2
				,custom3
				,custom4
				,custom5
				,plant
				,invoice_number
				,notes
				,gl_account
				,package_type
				,suffix
				,due_date
				,group_no
				,sales_order
				,release_no
				,dropship_shipper
				,std_cost
				,user_defined_status
				,engineering_level
				,posted
				,parent_serial
				,origin
				,destination
				,sequence
				,object_type
				,part_name
				,start_date
				,field1
				,field2
				,show_on_shipper
				,tare_weight
				,kanban_number
				,dimension_qty_string
				,dim_qty_string_other
				,varying_dimension_code
				,invoice
				,invoice_line
				,dbdate
			)
			select 
				 serial
				,@DateStamp
				,'W2'
				,@HarnessPartNumber
				,quantity = @HarnessStdQuantity * @AlabamaPartQuantity -- FT.BOM.StdQty * finished part quantity returned
				,remarks
				,price
				,''
				,customer
				,''
				,po_number
				,@OperatorCode
				,fromLoc
				,'QC-1'
				,on_hand = (select SUM(quantity) from object where part = @HarnessPartNumber and status = 'A')
				,''
				,0
				,@Status
				,@NextShipper
				,''
				,''
				,'EA'
				,null
				,std_quantity = @HarnessStdQuantity * @AlabamaPartQuantity -- FT.BOM.StdQty * finished part quantity returned
				,cost = (select material_cum from dbo.part_standard where part = @HarnessPartNumber)
				,''
				,''
				,''
				,''
				,''
				,''
				,plant
				,null
				,@RmaNotes
				,gl_account
				,''
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,std_cost = (select material_cum from dbo.part_standard where part = @HarnessPartNumber)
				,@UserDefinedStatus
				,NULL
				,'N'
				,NULL
				,@NextShipper
				,fromLoc
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,'N'
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,@DateStamp
			from 
				#SerialRma srma
			where
				srma.serial = @AlabamaSerial

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
			
			
			
		
			
			-- Create new serial numbers for each bulb child part and scrap them.  (No objects will be created.)
			declare
				@BulbPartNumber varchar(25)
			,	@BulbStdQuantity numeric(20,6)
			,	@FirstNewSerial int
			,	@SerialCount int	
			,	@SerialIncrement int
				
			select
				@SerialCount = count(1)
			from	
				@tempBulbPartsList
		
		
			if (@SerialCount > 0 ) begin

				--- <Call>	
				set	@CallProcName = 'monitor.usp_NewSerialBlock'
				execute
					@ProcReturn = monitor.usp_NewSerialBlock
						@SerialBlockSize = @SerialCount
					,	@FirstNewSerial = @FirstNewSerial out
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
			
			end
			
			
			select @SerialIncrement = 0
			
			while ((select count(1) from @tempBulbPartsList where Processed = 0) > 0) begin
		
				select
					@BulbPartNumber = min(bpl.BulbPart)
				from
					@tempBulbPartsList bpl
				where
					bpl.Processed = 0
					
				select
					@BulbStdQuantity = bpl.StdQuantity
				from
					@tempBulbPartsList bpl
				where
					bpl.BulbPart = @BulbPartNumber
				
				
				
				/*	Create quality (scrap) audit trail record.  */
				declare
					@QualityATType char(1)
				,	@QualityATRemarks char(1)

				set	@QualityATType = 'Q'
				set @QualityATRemarks = 'Quality'

				--- <Insert rows="1">
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
					serial = @FirstNewSerial + @SerialIncrement
				,   date_stamp = @TranDT
				,   type = @QualityATType
				,   part = @BulbPartNumber
				,   quantity = @BulbStdQuantity * @AlabamaPartQuantity -- FT.BOM.StdQty * finished part quantity returned
				,   remarks = @QualityATRemarks
				,   price = srma.price
				,   salesman = ''
				,   customer = srma.customer
				,   vendor = ''
				,   po_number = srma.po_number
				,   operator = @OperatorCode
				,   from_loc = convert(varchar(10), @AlabamaSerial)
				,   to_loc = 'S'
				,   on_hand = (select SUM(quantity) from object where part = @BulbPartNumber and status = 'A')
				,   lot = ''
				,   weight = 0
				,   status = 'S'
				,   shipper = @NextShipper
				,   flag = ''
				,   activity = ''
				,   unit = 'EA'
				,   workorder = null
				,   std_quantity = @BulbStdQuantity * @AlabamaPartQuantity -- FT.BOM.StdQty * finished part quantity returned
				,   cost = (select material_cum from dbo.part_standard where part = @BulbPartNumber)
				,   control_number = ''
				,   custom1 = ''
				,   custom2 = ''
				,   custom3 = ''
				,   custom4 = ''
				,   custom5 = ''
				,   plant = srma.plant
				,   invoice_number = ''
				,   notes = 'Scrapped bulb serial as part of Alabama RMA/RTV process.'
				,   gl_account = srma.gl_account
				,   package_type = ''
				,   suffix = ''
				,   due_date = null
				,   group_no = ''
				,   sales_order = ''
				,   release_no = ''
				,   dropship_shipper = null
				,   std_cost = (select material_cum from dbo.part_standard where part = @BulbPartNumber)
				,   user_defined_status = 'Scrapped'
				,   engineering_level = null
				,   posted = 'N'
				,   parent_serial = null
				,   origin = @NextShipper
				,   destination = srma.fromLoc
				,   sequence = null
				,   object_type = null
				,   part_name = (select name from part where part = @BulbPartNumber)
				,   start_date = null
				,   field1 = null
				,   field2 = null
				,   show_on_shipper = 'N'
				,   tare_weight = null
				,   kanban_number = null
				,   dimension_qty_string = null
				,   dim_qty_string_other = null
				,   varying_dimension_code = null
				from
					#SerialRma srma
				where
					srma.serial = @AlabamaSerial

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
				
				

				
				/*	Create 'delete' audit trail record.  */
				--- <Insert rows="1">
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
					serial = @FirstNewSerial + @SerialIncrement
				,   date_stamp = @TranDT
				,   type = 'D'
				,   part = @BulbPartNumber
				,   quantity = 0
				,   remarks = 'Delete'
				,   price = srma.price
				,   salesman = ''
				,   customer = srma.customer
				,   vendor = ''
				,   po_number = srma.po_number
				,   operator = @OperatorCode
				,   from_loc = convert(varchar(10), @AlabamaSerial)
				,   to_loc = 'TRASH'
				,   on_hand = (select SUM(quantity) from object where part = @BulbPartNumber and status = 'A')
				,   lot = ''
				,   weight = 0
				,   status = 'S'
				,   shipper = @NextShipper
				,   flag = ''
				,   activity = ''
				,   unit = 'EA'
				,   workorder = null
				,   std_quantity = 0
				,   cost = (select material_cum from dbo.part_standard where part = @BulbPartNumber)
				,   control_number = ''
				,   custom1 = ''
				,   custom2 = ''
				,   custom3 = ''
				,   custom4 = ''
				,   custom5 = ''
				,   plant = srma.plant
				,   invoice_number = ''
				,   notes = 'Deleted bulb serial as part of Alabama RMA/RTV process.'
				,   gl_account = srma.gl_account
				,   package_type = ''
				,   suffix = ''
				,   due_date = null
				,   group_no = ''
				,   sales_order = ''
				,   release_no = ''
				,   dropship_shipper = null
				,   std_cost = (select material_cum from dbo.part_standard where part = @BulbPartNumber)
				,   user_defined_status = 'Scrapped'
				,   engineering_level = null
				,   posted = 'N'
				,   parent_serial = null
				,   origin = @NextShipper
				,   destination = srma.fromLoc
				,   sequence = null
				,   object_type = null
				,   part_name = (select name from part where part = @BulbPartNumber)
				,   start_date = null
				,   field1 = null
				,   field2 = null
				,   show_on_shipper = 'N'
				,   tare_weight = null
				,   kanban_number = null
				,   dimension_qty_string = null
				,   dim_qty_string_other = null
				,   varying_dimension_code = null
				from
					#SerialRma srma
				where
					srma.serial = @AlabamaSerial

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
				
				


				update
					@tempBulbPartsList
				set
					Processed = 1
				where
					BulbPart = @BulbPartNumber
			
			
				select @SerialIncrement = @SerialIncrement + 1 
			
			end				
				
			
			
			
			-- For the RTV for this serial, change the finished part in the temp table to the harness part number			
			update
				#SerialRma
			set
				part = @HarnessPartNumber
			,	CustomerPart = @HarnessCustomerPartNumber
			,	PartName = @HarnessPartName
			where
				serial = @AlabamaSerial
				
			-- Also update the object to the harness part number
			update
				dbo.object
			set
				part = @HarnessPartNumber
			where
				serial = @AlabamaSerial
				
					

			-- Next serial loop
			update
				@tempSerialsList
			set
				Processed = 1
			where
				serial = @AlabamaSerial
			
		end


	end -- ends if @AlabamaPart is actually an Alabama part
	
	
	-- Next part loop
	update
		@tempPartsList
	set
		Processed = 1
	where
		Part = @AlabamaPart
	
end







if (@CreateRTV = 1) begin

	select 
		@NextShipperRTV = shipper 
	from 
		dbo.parameters
		

	--- <Update rows="1">
	set	@TableName = 'dbo.parameters'

	update 
		dbo.parameters 
	set 
		shipper = shipper + 1

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
		RAISERROR ('Error updating table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Update>

	--- <Insert rows="1">
	set	@TableName = 'dbo.shipper'	

	insert dbo.shipper
	( 
		id,
		destination,
		status,
		customer,
		type,
		date_stamp,
		cs_status,
		operator
	)
	select	
		@NextShipperRTV,
		'EmpHond',
		'O',
		'',
		'V',
		@DateStamp,
		'Approved',
		@OperatorCode

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


	--- <Insert rows="1+">
	set	@TableName = 'dbo.shipper_detail'	

	insert dbo.shipper_detail
	(	
		shipper,
		part,
		qty_required,
		qty_packed,
		qty_original,
		accum_shipped,
		order_no,
		type,
		price,
		account_code,
		Operator,
		Boxes_staged,
		alternative_qty,
		Alternative_unit,
		Price_type,
		customer_part,
		suffix,
		part_name,
		part_original,
		stage_using_weight,
		alternate_price,
		old_suffix,
		old_shipper
	)
	select  
		@NextShipperRTV,
		SRMA.part,
		sum(SRMA.quantity) Qty,
		sum(SRMA.quantity) qtypacked,
		sum(SRMA.quantity) QtyOriginal,
		0,
		0,
		'I',
		NULL,
		'4030',
		@OperatorCode,
		count(1),
		sum(SRMA.quantity),
		'EA',
		'P',
		max(CustomerPart),
		0,
		max(PartName),
		SRMA.Part,
		'N',
		NULL,
		0,
		Null
	from 
		#SerialRma SRMA
		join part_eecustom peec 
			on peec.part =  SRMA.part
	group by 
		SRMA.part
		  
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
		 

	/*  Stage the objects if they have not been placed on hold.  */
	if (@PlaceSerialsOnHold = 0) begin
		--- <Update>
		set	@TableName = 'dbo.object'

		update 
			dbo.object 
		set 
			shipper = @NextShipperRTV 
		,	show_on_shipper = 'Y'
		where 
			serial in ( select serial from #SerialRma )

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
		
		
		/*  Update the RTV shipper as staged  */
		--- <Update rows="1">
		set	@TableName = 'dbo.shipper'

		update 
			dbo.shipper
		set 
			status = 'S'
		where 
			id = @NextShipperRTV

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

	end
	
	

	-- Determine if an Alabama finished good was RMA'd
	if exists (
			select
				1
			from
				dbo.audit_trail at
			where
				shipper = convert(varchar(20), @NextShipper)
				and type = 'W1' ) begin
	
		-- Update the previously created W1 (Alabama finished good) RTV record(s) with the RTV shipper number.
		--- <Update rows="1">
		set	@TableName = 'dbo.audit_trail' 
		update
			dbo.audit_trail
		set
			shipper = convert(varchar(20), @NextShipperRTV)
		,	origin = convert(varchar(20), @NextShipperRTV)
		where
			type = 'W1'
			and shipper = convert(varchar(20), @NextShipper)
			
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
			
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			return
		end
		if	@RowCount = 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Rows inserted: %d.  Expected rows: >0.', 16, 1, @TableName, @ProcName, @RowCount)
			rollback tran @ProcName
			return
		end
		--- </Update>

	end
	
end
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

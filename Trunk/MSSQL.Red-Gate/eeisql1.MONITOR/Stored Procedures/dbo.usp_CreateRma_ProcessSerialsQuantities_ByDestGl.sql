SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[usp_CreateRma_ProcessSerialsQuantities_ByDestGl]
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
	part_standard.material_cum materialCum,
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
	onHand ,
	weight,
	Status,
	shipper,
	origin,
	std_quantity,
	material_cum,					
	plant,
	note,
	gl_account,
	material_cum materialCum,
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
	,(select SUM(quantity) from object where part = SRMA.part)
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
	,'11'
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
		part_standard.material_cum,
		part_standard.material_cum,
		parent_serial,
		SRMA.plant,
		@UserDefinedStatus,
		SRMA.po_number
	
From	#SerialRma SRMA
join	part_standard on SRMA.part = part_standard.part


select	@Error = @@Error,
		@RowCount = @@Rowcount

if	@Error != 0  or @RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR ('Failed to Create Objects%S', 16, 1, '-Auto Create RMA Process')
	rollback tran CreateRMA
	return	@Result
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

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[usp_CreateRma_ProcessSerials]
	@RmaNumber varchar(50)
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
	@NextShipper int
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
,	@RtvNotes varchar(255)

select
	@DateStamp = getdate()	
select		
	@RmaNotes = @RmaNumber + ' : Auto RMA : Created via SQL Script :'
select		
	@RtvNotes = 'Auto RTV : Created via SQL Script'

select			
	at.serial,
	@DateStamp dateStamp,
	'U' attype,
	at.part,
	quantity,
	'RMA' Remarks,
	(Select MAX(alternate_price) from shipper_detail sd where convert(varchar(25), sd.shipper) =  at.shipper and part_original = at.part ) as price,
	customer,
	'ASB' operator,
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
	(Select MAX(shipper) from audit_trail at2 where  at2.part = at.part and at2.type = 'S' and at2.shipper >= at.shipper) as sdshipper
into  
	#SerialRma
from 
	dbo.SerialsToAutoRMA_RTV srma
	left join dbo.audit_trail at 
		on at.serial = srma.serial 
		and at.type = 'S' 
		and at.date_stamp = (select max(date_stamp) from audit_trail at2 where at2.type = 'S' and at2.serial = at.serial)
	join dbo.part_standard 
		on part_standard.part = at.part
	join dbo.shipper_detail sd 
		on convert(varchar(25), sd.shipper) = at.shipper 
		and sd.part_original = at.part


--Select * from shipper where type = 'R'


--- <Insert rows="1+">
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
	'ASB'
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
if	@RowCount = 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: >0.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>	



-- Insert shipper_detail.  Get the correct sales return account for each part.
declare @tempParts table
(
	Part varchar(25)
,	Processed int
)

insert @tempParts
(
	Part
,	Processed
)
select
	SRMA.Part
,	0
from
	#SerialRma SRMA
group by
	SRMA.Part


	
declare
	@Part varchar(25)
,	@SalesReturnAccount varchar(75)

select
	@Part = min(tp.Part)
from
	@tempParts tp
where
	tp.Processed = 0
		
while ((select count(1) from @tempParts where Processed = 0) > 0) begin

	select 
		@SalesReturnAccount = coalesce(max(pe.sales_return_account), '')
	from
		eehsql1.eeh.dbo.part_eecustom pe
	where
		pe.part = @Part
		
	
		
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
		sum(quantity) * -1,
		sum(quantity) * -1,
		0,
		(select max(order_no) from order_header where shipper = ( select max(shipper) from #SerialRma) and blanket_part = SRMA.part),
		'I',
		price,
		sales_return_account,
		'ASB',
		count(1),
		sum(quantity) * -1,
		'EA',
		'P',
		CustomerPart,
		0,
		PartName,
		SRMA.Part,
		'N',
		SdPrice,
		0,
		sdShipper
	from 
		#SerialRma SRMA
		join part_eecustom peec 
			on peec.part =  SRMA.part
	where
		SRMA.part = @Part
	group by 
		SRMA.part,
		price,
		CustomerPart,
		PartName, 
		SdPrice, 
		sdshipper, 
		sales_return_account
				
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
	
		
		
	update
		@tempParts
	set
		Processed = 1
	where
		Part = @Part
			
	select
		@Part = min(tp.Part)
	from
		@tempParts tp
	where
		tp.Processed = 0

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
	,NULL
	,'ASB'
	,fromLoc
	,'QC-1'
	,(select SUM(quantity) from object where part = SRMA.part)
	,''
	,0
	,'A'
	,@NeXtShipper
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
	,'Approved'
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


--drop table #SerialRma


-- Create RTV Shipper
--
declare 
	@NextShipperRTV int
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

--- <Insert rows="1+">
set	@TableName = 'dbo.shipper'	

--! something missing here ***
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
	'ASB'

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
	sum(quantity) qtypacked,
	sum(quantity) QtyOriginal,
	0,
	NULL,
	'I',
	NULL,
	'4030',
	'ASB',
	count(1),
	sum(quantity),
	'EA',
	'P',
	CustomerPart,
	0,
	PartName,
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
	SRMA.part,
	price,
	CustomerPart, 
	PartName, 
	SdPrice, 
	sdshipper, 
	sales_return_account
	  
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
	 

--- <Update>
set	@TableName = 'dbo.object'

update 
	dbo.object 
set 
	shipper = @NextShipperRTV, 
	show_on_shipper = 'Y'
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

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_CreateRma_TransferOnHoldSerials]
	@OperatorCode varchar(5)
,	@RmaShipper int
,	@Location varchar(25)
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
/*  Valid location  */
if not exists (
		select
			1
		from
			dbo.location l
		where
			l.code = @Location ) begin
	
	set	@Result = 999900
	RAISERROR ('Location %s not valid.  Procedure %s.', 16, 1, @Location, @ProcName)
	rollback tran @ProcName
	return	
end
---	</ArgumentValidation>


--- <Body>
declare	
	@Notes varchar(255)
select		
	@Notes = 'Transfer of serials for RMA shipper: ' + convert(varchar(25), @RmaShipper) + '.'


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
	at2.serial
	,@TranDT
	,'T'
	,at2.part
	,at2.quantity
	,'Transfer'
	,at2.price
	,at2.salesman
	,at2.customer
	,at2.vendor
	,at2.po_number
	,@OperatorCode
	,at2.to_loc
	,@Location
	,at2.on_hand
	,at2.lot
	,at2.weight
	,at2.status
	,at2.shipper
	,at2.flag
	,at2.activity
	,at2.unit
	,at2.workorder
	,at2.std_quantity
	,at2.cost
	,at2.control_number
	,at2.custom1
	,at2.custom2
	,at2.custom3
	,at2.custom4
	,at2.custom5
	,at2.plant
	,at2.invoice_number
	,@Notes
	,at2.gl_account
	,at2.package_type
	,at2.suffix
	,at2.due_date
	,at2.group_no
	,at2.sales_order
	,at2.release_no
	,at2.dropship_shipper
	,at2.std_cost
	,at2.user_defined_status
	,at2.engineering_level
	,at2.posted
	,at2.parent_serial
	,at2.origin
	,at2.destination
	,at2.sequence
	,at2.object_type
	,at2.part_name
	,at2.start_date
	,at2.field1
	,at2.field2
	,at2.show_on_shipper
	,at2.tare_weight
	,at2.kanban_number
	,at2.dimension_qty_string
	,at2.dim_qty_string_other
	,at2.varying_dimension_code
	,at2.invoice
	,at2.invoice_line
	,@TranDT
from 
	dbo.audit_trail at2
where
	at2.shipper = convert(varchar(25), @RmaShipper)
	and at2.type = 'U'

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
	location = @Location
where
	shipper = @RmaShipper
--	serial in
--		(	select
--				at.serial
--			from
--				dbo.audit_trail at
--			where
--				at.shipper = convert(varchar(25), @RmaShipper)
--				and at.type = 'U' )

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
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: >0.', 16, 1, @TableName, @ProcName, @RowCount)
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

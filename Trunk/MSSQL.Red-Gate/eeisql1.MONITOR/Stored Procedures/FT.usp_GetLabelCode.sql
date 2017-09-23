SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[usp_GetLabelCode]
	@Serial int							--[ObjectSerial]
,	@LabelName sysname
,	@PrinterType sysname
,	@NumberOfLabels int					--[NumberOfLabels]
,	@LabelCode varchar(8000) out
as
set nocount on
set ansi_warnings off

--- <Error Handling>
declare
    @CallProcName sysname
,	@TableName sysname
,	@ProcName sysname
,	@ProcReturn integer
,	@ProcResult integer
,	@Error integer
,	@RowCount integer
,	@Result integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. <schema_name, sysname, dbo>.usp_Test
--- </Error Handling>

--- <Validation>
if	exists
	(	select
			*
		from
			dbo.audit_trail at
		where
			at.serial = @Serial
			and at.type = 'S'
	) begin
	set	@Result = 999999
	RAISERROR ('Error returning label data.  Serial %d has already been shipped.', 16, 1, @TableName, @ProcName, @Serial)
	rollback tran @ProcName
	return
end
--- </Validation>

--- <Body>
/*	If pre-object doesn't exist, create it. */
--	I.	If this box has been deleted, recreate it.
if	not exists
	(	select	1
		from	object
		where	serial = @Serial) begin

	insert
		dbo.object
	(	serial
	,	part
	,	location
	,	last_date
	,	unit_measure
	,	operator
	,	status
	,	quantity
	,	plant
	,	std_quantity
	,	last_time
	,	user_defined_status
	,	type
	,	po_number 
	)
	select
		poh.Serial
	,	poh.part
	,	location = FT.fn_VarcharGlobal ('AssemblyPreObject')
	,	poh.CreateDT
	,	(select standard_unit from part_inventory where part = poh.Part)
	,	poh.Operator
	,	'H'
	,	poh.Quantity
	,	(select plant from location where code = FT.fn_VarcharGlobal ('AssemblyPreObject'))
	,	poh.Quantity
	,	poh.CreateDT
	,	'PRESTOCK'
	,	null
	,	null
	from
		FT.PreObjectHistory poh
	where
		poh.Serial = @Serial
end

/*	All available label data tokens. */
declare
    @Objectserial int
,	@Qty int
,	@PartName varchar(50)
,	@BlanketPart varchar(50)
,	@CustomerPart varchar(50)
,	@CustPO varchar(50)
,	@SupplierPrefix varchar(50)
,	@SupplierName varchar(50)
,	@ShipTo varchar(50)
,	@ShipAdd1 varchar(50)
,	@ShipAdd2 varchar(50)
,	@ShipAdd3 varchar(50)
,	@CompAdd1 varchar(50)
,	@CompAdd2 varchar(50)
,	@ShipDate varchar(50)

select
	@ObjectSerial = o.serial
,	@Qty = o.std_quantity
,	@PartName = p.name
,	@BlanketPart = oh.blanket_part
,	@CustomerPart = oh.customer_part
,	@CustPO = oh.customer_po
,	@SupplierPrefix = 'AAV'
,	@SupplierName = 'EMPIRE ELECTRONICS'
,	@ShipTo = d.destination
,	@ShipAdd1 = d.address_1
,	@ShipAdd2 = d.address_2
,	@ShipAdd3 = d.address_3
,	@CompAdd1 = parm.address_1
,	@CompAdd2 = parm.address_2
,	@ShipDate = upper(replace(convert(varchar(15), getdate(), 106), ' ', '' ))
from
	dbo.object o
	join dbo.part p
		on p.part = o.part
	cross apply
		(	select
				LastOrderNo = max(oh.order_no)
			from
				dbo.order_header oh
			where
				oh.blanket_part = o.part
		) loh
	join dbo.order_header oh
		join dbo.destination d
			on d.destination = oh.destination
		on oh.order_no = loh.LastOrderNo
	cross join dbo.parameters parm
where
	o.serial = @Serial

declare
	@labelRaw varchar(8000)

select
	@labelRaw = ld.LabelCode
from
	dbo.LabelDefinitions ld
where
	LabelName = 'FIN_PLEX'

/*	Replace label code with the read values. */
set	@labelRaw = replace(@labelRaw, '[ObjectSerial]', coalesce(convert(varchar, @Serial),''))
set	@labelRaw = replace(@labelRaw, '[Qty]', coalesce(convert(varchar, @Qty),''))
set	@labelRaw = replace(@labelRaw, '[PartName]', coalesce(@PartName,''))
set	@labelRaw = replace(@labelRaw, '[BlanketPart]', coalesce(@BlanketPart,''))
set	@labelRaw = replace(@labelRaw, '[CustomerPart]', coalesce(@CustomerPart,''))
set	@labelRaw = replace(@labelRaw, '[CustPO]', coalesce(@CustPO,''))
set	@labelRaw = replace(@labelRaw, '[SupplierPrefix]', coalesce(@SupplierPrefix,''))
set	@labelRaw = replace(@labelRaw, '[SupplierName]', coalesce(@SupplierName,''))
set	@labelRaw = replace(@labelRaw, '[ShipTo]', coalesce(@ShipTo,''))
set	@labelRaw = replace(@labelRaw, '[ShipAdd1]', coalesce(@ShipAdd1,''))
set	@labelRaw = replace(@labelRaw, '[ShipAdd2]', coalesce(@ShipAdd2,''))
set	@labelRaw = replace(@labelRaw, '[ShipAdd3]', coalesce(@ShipAdd3,''))
set	@labelRaw = replace(@labelRaw, '[CompAdd1]', coalesce(@CompAdd1,''))
set	@labelRaw = replace(@labelRaw, '[CompAdd2]', coalesce(@CompAdd2,''))
set	@labelRaw = replace(@labelRaw, '[ShipDate]', coalesce(@ShipDate,''))
set	@labelRaw = replace(@labelRaw, '[NumberOfLabels]', '1')

/*	If object is a pre-object and the status of that pre-object is not yet completed, delete object. */
if	exists
	(	select
			*
		from
			FT.PreObjectHistory poh
		where
			poh.Serial = @Serial
			and poh.Status = 0
	)
	and exists
	(	select
			*
		from
			dbo.object o
		where
			serial = @Serial
	) begin
	
	--- <Delete rows="1">
	set	@TableName = 'dbo.object'
	
	delete
		o
	from
		dbo.object o
	where
		serial = @Serial
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Rows deleted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Delete>
	
end
--- </Body>

set	@LabelCode = @labelRaw

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
	@serial int
,	@labelName sysname
,	@printerType sysname
,	@numberOfLabels int
,	@labelCode varchar(8000)

set	@serial = 10580799
set	@labelName = 'GenericFin'
set	@printerType = 'Zebra'
set	@numberOfLabels = 2

begin transaction Test

declare
	@ProcReturn integer
,	@Error integer

execute
	@ProcReturn = FT.usp_GetLabelCode
	@Serial = @serial
,	@LabelName = @labelName
,	@PrinterType = @printerType
,	@NumberOfLabels = @numberOfLabels
,	@LabelCode = @labelCode out

set	@Error = @@error

select
	@Error, @ProcReturn, @Serial, @LabelCode
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

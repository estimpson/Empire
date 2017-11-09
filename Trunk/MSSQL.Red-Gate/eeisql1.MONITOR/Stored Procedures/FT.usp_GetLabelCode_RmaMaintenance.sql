SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[usp_GetLabelCode_RmaMaintenance]
	@Serial int
,	@LabelCode varchar(8000) out
as
set nocount on
set ansi_warnings off

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
--- </Tran>


--- <Validation>
/*  Object exists in the Honduras database  */
if not exists (
		select
			*
		from
			dbo.object o
		where
			o.serial = @Serial ) begin

	RAISERROR ('Cannot print a label because object %d does not exist in the Troy database.  Procedure %s', 16, 1, @Serial, @ProcName)
	rollback tran @ProcName
	return
end
--- </Validation>


--- <Body>
/*  Get label data  */ 
declare
	@CustomerPart varchar(50)
,	@Quantity varchar(25)
,	@SupplierCode varchar(50)
,	@PartName varchar(250)
,	@MfgDate varchar(25)
,	@Operator varchar(25)
,	@PartNumber varchar(50)

select
	@CustomerPart = p.cross_ref
,	@Quantity = convert(varchar, convert(int, o.std_quantity))
,	@PartName = substring(p.name, 1, 34)
,	@MfgDate = convert(char(8), o.last_date, 1)
,	@Operator = o.operator
,	@PartNumber = p.part
from
	dbo.object o
	join dbo.part p
		on p.part = o.part
where
	o.serial = @Serial


/*  Get raw label code  */
declare
	@labelRaw varchar(8000)

select
	@labelRaw = ld.LabelCode
from
	dbo.LabelDefinitions ld
where
	LabelName = 'HON_INTERNAL'
	and PrinterType = 'Sato'

/*	Replace label code with the read values. */
set	@labelRaw = replace(@labelRaw, '[Serial]', coalesce(convert(varchar, @Serial),''))
set	@labelRaw = replace(@labelRaw, '[CustomerPart]', coalesce(@CustomerPart,''))
set	@labelRaw = replace(@labelRaw, '[Quantity]', coalesce(convert(varchar, @Quantity),''))
set	@labelRaw = replace(@labelRaw, '[SupplierCode]', coalesce(@SupplierCode,''))
set	@labelRaw = replace(@labelRaw, '[PartName]', coalesce(@PartName,''))
set	@labelRaw = replace(@labelRaw, '[MfgDate]', coalesce(@MfgDate,''))
set	@labelRaw = replace(@labelRaw, '[Operator]', coalesce(@Operator,''))
set	@labelRaw = replace(@labelRaw, '[PartNumber]', coalesce(@PartNumber,''))


set	@LabelCode = @labelRaw
--- </Body>



---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>



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

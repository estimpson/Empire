SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[usp_GetLabelCode_bk]
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
    @partCodeOut varchar(25)			--[PartCode]
,	@partNameOut varchar(100)			--[PartName]
,	@customerPartOut varchar(50)		--[CustomerPart]
,	@partXRefOut varchar(50)			--[PartXRef]
,	@objectQtyOut varchar(8)			--[ObjectQty]
,	@operatorCodeOut varchar(25)		--[OperatorCode]
,	@description1Out varchar(50)		--[Description1]
,	@description2Out varchar(50)		--[Description2]
,	@engineeringLevelOut varchar(10)	--[EngineeringLevel]
,	@mfgDateOut varchar(12)				--[MfgDate]
,	@companyAddressOut varchar(50)		--[CompanyAddress]
,	@supplierCodeOut varchar(40)		--[SupplierCode]

/*	Get label raw format and data procedure, parms. */
declare
	@labelRaw varchar(8000)
,	@procedureName sysname
,	@procedureArguments varchar(8000)

select
	@labelRaw = ld.LabelCode
,	@procedureName = ld.ProcedureName
,	@procedureArguments = ld.ProcedureArguments
from
	dbo.LabelDefinitions ld
where
	ld.LabelName = @LabelName
	and
		ld.PrinterType = @PrinterType

/*	Get label data from specified data procedure. */
declare
	@LabelCodeParms nvarchar(4000)
,	@getLabelDataSyntax nvarchar(4000)

set	@LabelCodeParms = N'
    @partCode varchar(25) output
,	@partName varchar(100) output
,	@customerPart varchar(100) output
,	@partXRef varchar(50) output
,	@objectQty varchar(8) output
,	@operatorCode varchar(25) output
,	@description1 varchar(50) output
,	@description2 varchar(50) output
,	@engineeringLevel varchar(10) output
,	@mfgDate varchar(12) output
,	@companyAddress varchar(50) output
,	@supplierCode varchar(40) output
'

/*
set	@getLabelDataSyntax = N'
exec ' + N'dbo.testProcedureName
	@Serial = ' + 'testSerial'
*/

set	@getLabelDataSyntax = N'
exec ' + @procedureName + N'
	@Serial = ' + convert(varchar, @Serial)

select
	@getLabelDataSyntax = @getLabelDataSyntax + N'
,	' + argumentName + N' = ' + argumentName + ' output'
from
	(	select
			argumentName = Value
		from
			FT.udf_SplitStringToRows(@procedureArguments, ',')
	) arguments

/*	Get label data. */
exec sp_executesql
	@getLabelDataSyntax
,	@LabelCodeParms
,	@partCode = @partCodeOut output
,	@partName = @partNameOut output
,	@customerPart = @customerPartOut output
,	@partXRef = @partXRefOut output
,	@objectQty = @objectQtyOut output
,	@operatorCode = @operatorCodeOut output
,	@description1 = @description1Out output
,	@description2 = @description2Out output
,	@engineeringLevel = @engineeringLevelOut output
,	@mfgDate = @mfgDateOut output
,	@companyAddress = @companyAddressOut output
,	@supplierCode = @supplierCodeOut output

/*	Replace label code with the read values. */
set	@labelRaw = replace(@labelRaw, '[ObjectSerial]', coalesce(convert(varchar, @Serial),''))
set	@labelRaw = replace(@labelRaw, '[PartCode]', coalesce(@partCodeOut,''))
set	@labelRaw = replace(@labelRaw, '[PartName]', coalesce(@partNameOut,''))
set	@labelRaw = replace(@labelRaw, '[CustomerPart]', coalesce(@customerPartOut,''))
set	@labelRaw = replace(@labelRaw, '[PartXRef]', coalesce(@partXRefOut,''))
set	@labelRaw = replace(@labelRaw, '[ObjectQty]', coalesce(@objectQtyOut,''))
set	@labelRaw = replace(@labelRaw, '[OperatorCode]', coalesce(@operatorCodeOut,''))
set	@labelRaw = replace(@labelRaw, '[Description1]', coalesce(@description1Out,''))
set	@labelRaw = replace(@labelRaw, '[Description2]', coalesce(@description2Out,''))
set	@labelRaw = replace(@labelRaw, '[EngineeringLevel]', coalesce(@engineeringLevelOut,''))
set	@labelRaw = replace(@labelRaw, '[MfgDate]', coalesce(@mfgDateOut,''))
set	@labelRaw = replace(@labelRaw, '[CompanyAddress]', coalesce(@companyAddressOut,''))
set	@labelRaw = replace(@labelRaw, '[SupplierCode]', coalesce(@supplierCodeOut,''))
set	@labelRaw = replace(@labelRaw, '[NumberOfLabels]', coalesce(convert(varchar, @NumberOfLabels),'1'))

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

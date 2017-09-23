SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EDI].[usp_XMLShipNotice_GetShipNoticeXML]
	@ShipperID int = 99622
,	@XMLShipNotice_FunctionName sysname = 'EDI_XML_Autosystems_ASN.udf_Root'
,	@PurposeCode char(2) = '00'
,	@Complete bit = 0
,	@XMLShipNotice xml = null out
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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
/*	Get the data. */
declare
	@Statement nvarchar(max) = '
select
	@XMLOutput = convert(nvarchar(max), ' + @XMLShipNotice_FunctionName + '(' + convert(varchar, @ShipperID) + ', ''' + @PurposeCode + ''', ' + convert(char(1), @Complete) + '))
'
,	@XMLOutput nvarchar(max)

execute
	sys.sp_executesql
	@stmt = @Statement
,	@parameters = N'@XMLOutput nvarchar(max) output'
,	@XMLOutput = @XMLOutput out

set	@XMLShipNotice = convert(xml, @XMLOutput)
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
	@ShipperID int = 99622
,	@XMLShipNotice_FunctionName sysname = 'EDI_XML_Autosystems_ASN.udf_Root'
,	@PurposeCode char(2) = '00'
,	@Complete bit = 0
,	@XMLShipNotice xml = null

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EDI.usp_XMLShipNotice_GetShipNoticeXML
	@ShipperID = @ShipperID
,	@XMLShipNotice_FunctionName = @XMLShipNotice_FunctionName
,	@PurposeCode = @PurposeCode
,	@Complete = @Complete
,	@XMLShipNotice = @XMLShipNotice out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	@XMLShipNotice
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

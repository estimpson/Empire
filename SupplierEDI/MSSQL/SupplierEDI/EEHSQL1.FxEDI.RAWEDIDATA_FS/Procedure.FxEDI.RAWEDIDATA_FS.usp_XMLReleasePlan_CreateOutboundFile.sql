
/*
Create Procedure.FxEDI.RAWEDIDATA_FS.usp_XMLReleasePlan_CreateOutboundFile.sql
*/

use FxEDI
go

if	objectproperty(object_id('RAWEDIDATA_FS.usp_XMLReleasePlan_CreateOutboundFile'), 'IsProcedure') = 1 begin
	drop procedure RAWEDIDATA_FS.usp_XMLReleasePlan_CreateOutboundFile
end
go

create procedure RAWEDIDATA_FS.usp_XMLReleasePlan_CreateOutboundFile
	@TradingPartner varchar(50)
,	@PurchaseOrderList varchar(max)
,	@FunctionName sysname
,	@XMLData varbinary(max)
,	@TestMailBox int
,	@FileGenerationTime datetime = null
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDISupplier.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
declare
	@fileStreamID table
(	FileStreamID uniqueidentifier
)

declare
	@outboundPath sysname =
		case
			when @TestMailBox = 1 then '\RawEDIData\SupplierEDI_TestMailBox\Outbound\Staging'
			else '\RawEDIData\SupplierEDI\Outbound\Staging'
		end
			
insert
	FxEDI.dbo.RawEDIData
(	file_stream
,	name
,	path_locator
)
output
	inserted.stream_id into @fileStreamID
values
(	@XMLData
,	FxEDI.RAWEDIDATA_FS.udf_GetNextOutboundXMLFileName (@outboundPath)
,	FxEDI.RAWEDIDATA_FS.udf_GetFilePathLocator(@outboundPath)
)
option (maxdop 1)

insert
	EEH.SupplierEDI.GenerationLog
(	FileStreamID
,	Type
,	TradingPartner
,	PurchaseOrderList
,	FunctionName
,	FileGenerationDT
,	OriginalFileName
,	CurrentFilePath
)
select
	FileStreamID = red.stream_id
,	Type = 1
,	@TradingPartner
,	@PurchaseOrderList
,	@FunctionName
,	FileGenerationDT = red.last_write_time
,	OriginalFileName = red.name
,	CurrentFilePath = red.file_stream.GetFileNamespacePath()
from
	FxEDI.dbo.RawEDIData red
	join @fileStreamID fsi
		on fsi.FileStreamID = red.stream_id
--- </Body>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
go

begin transaction
select
	RAWEDIDATA_FS.udf_GetNextOutboundXMLFileName('\RawEDIData\SupplierEDI_TestMailBox\Outbound\Staging')
,	RAWEDIDATA_FS.udf_GetFilePathLocator('\RawEDIData\SupplierEDI_TestMailBox\Outbound\Staging')

declare
	@XMLData varbinary(max) =
		convert
		(	varbinary(max)
			,	(	select
						EEH.EDI_XML_NET_830.Get830('ARROW', '31017, 31458', '05', 0)
				)
		)

exec
	RAWEDIDATA_FS.usp_XMLReleasePlan_CreateOutboundFile
	@TradingPartner = 'ARROW'
,	@PurchaseOrderList = '31017, 31458'
,	@FunctionName = 'EDI_XML_NET_830.Get830'
,	@XMLData = @XMLData
,	@TestMailBox = 1
,	@FileGenerationTime = null

select
	*
from
	RAWEDIDATA_FS.udf_DIR('\SupplierEDI_TestMailBox\Outbound\Staging', 1)

select
	*
from
	EEH.SupplierEDI.GenerationLog	

rollback

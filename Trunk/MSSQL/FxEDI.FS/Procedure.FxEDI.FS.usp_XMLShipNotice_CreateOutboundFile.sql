
/*
Create Procedure.FxEDI.FS.usp_XMLShipNotice_CreateOutboundFile.sql
*/

use FxEDI
go

if	objectproperty(object_id('FS.usp_XMLShipNotice_CreateOutboundFile'), 'IsProcedure') = 1 begin
	drop procedure FS.usp_XMLShipNotice_CreateOutboundFile
end
go

create procedure FS.usp_XMLShipNotice_CreateOutboundFile
	@XMLData varbinary(max)
,	@ShipperID int
,	@FTPMailBox int
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
			when @FTPMailBox = 0 then '\RawEDIData\CustomerEDI_TestMailBox\Outbound\Staging'
			when @FTPMailBox = 1 then '\RawEDIData\CustomerEDI\Outbound\Staging'
			else '\RawEDIData\Drafts'
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
,	FxEDI.FS.udf_GetNextRawEDIData_OutboundXML_FileName (@outboundPath)
,	FxEDI.FS.udf_GetFilePathLocator(@outboundPath)
)

insert
	EEISQL1.MONITOR.dbo.CustomerEDI_GenerationLog
(	FileStreamID
,	Type
,	ShipperID
,	FileGenerationDT
,	OriginalFileName
,	CurrentFilePath
)
select
	FileStreamID = red.stream_id
,	Type = 1
,	ShipperID = @ShipperID
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
GO

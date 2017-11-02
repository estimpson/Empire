SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [FTP].[usp_ReceiveCustomerEDI_v2]
	@ReceiveFileFromFolderRoot sysname = '\RawEDIData\CustomerEDI\Inbound'
,	@TranDT datetime = null out
,	@Result integer = null out
as
set	nocount on
set	ansi_warnings on
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname
,	@TableName sysname
,	@ProcName sysname
,	@ProcReturn integer
,	@ProcResult integer
,	@Error integer
,	@ErrorMessage varchar(2047)
,	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDI.usp_Test
--- </Error Handling>

--- <Tran Allowed=No AutoCreate=No TranDTParm=Yes>
if	@@TRANCOUNT > 0 begin

	RAISERROR ('This procedure cannot be run in the context of a transaction.', 16, 1, @ProcName)
	return
end

set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
declare
	@processStep numeric(20,6)
,	@command varchar(max)

declare
	@inboundFolder sysname = @receiveFileFromFolderRoot
,	@inProcessFolder sysname = @receiveFileFromFolderRoot + '\InProcess'
,	@archiveFolder sysname = @receiveFileFromFolderRoot + '\Archive'
,	@errorFolder sysname = @receiveFileFromFolderRoot + '\Error'
,	@moveFilePrefix sysname = Replace(convert(varchar(50), getdate(), 126), ':', '') + '.'

declare
	@fhlRow int

insert
	FTP.LogHeaders with (tablockx)
(	Type
,	Description
)
select
	Type = 1
,	Description = 'Receive EDI.'

set	@fhlRow = scope_identity()
set	@processStep = 0
set @command = 'Validate Input Queue.'

if	exists
	(	select
			*
		from
			dbo.RawEDIData redInboundFolder
			join dbo.RawEDIData redInboundFiles
				on redInboundFiles.parent_path_locator = redInboundFolder.path_locator
				and redInboundFiles.is_directory = 0
		where
			redInboundFolder.is_directory = 1
			and redInboundFolder.file_stream.GetFileNamespacePath() = @inProcessFolder
	) begin

	insert
		FTP.LogDetails
	(	FLHRowID
	,	Line
	,	Command
	,	CommandOutput
	)
	select
		FLHRowID = @fhlRow
	,	Line = @processStep
	,	Command = @command
	,	CommandOutput = 'Input Queue not empty.'

	/*	Move files to an error folder. */
	set	@processStep = 0.1
	set @command = 'Empty out InProcess folder.'

	--- <Call>
	set	@CallProcName = 'FS.usp_FileTable_FileMove'
	execute
		@ProcReturn = FS.usp_FileTable_FileMove
			@FromFolder = @inProcessFolder
		,	@ToFolder = @errorFolder
		,	@FileNamePattern = '%'
		,	@FileAppendPrefix = @moveFilePrefix
		,	@TranDT = @TranDT out
		,	@Result = @ProcResult out

	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		set @ErrorMessage = formatmessage ('Error encountered in %s.  Error: %d while calling %s', @ProcName, @Error, @CallProcName)
		raiserror (@ErrorMessage, 16, 1)
		goto ERROR_HANDLING
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		set @ErrorMessage = formatmessage ('Error encountered in %s.  ProcReturn: %d while calling %s', @ProcName, @ProcReturn, @CallProcName)
		raiserror (@ErrorMessage, 16, 1)
		goto ERROR_HANDLING
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		set @ErrorMessage = formatmessage ('Error encountered in %s.  ProcResult: %d while calling %s', @ProcName, @ProcResult, @CallProcName)
		raiserror (@ErrorMessage, 16, 1)
		goto ERROR_HANDLING
	end
	--- </Call>

	insert
		FTP.LogDetails
	(	FLHRowID
	,	Line
	,	Command
	,	CommandOutput
	)
	select
		FLHRowID = @fhlRow
	,	Line = @processStep
	,	Command = @command
	,	CommandOutput = 'SUCCESS'
end
else begin
	insert
		FTP.LogDetails
	(	FLHRowID
	,	Line
	,	Command
	,	CommandOutput
	)
	select
		FLHRowID = @fhlRow
	,	Line = @processStep
	,	Command = @command
	,	CommandOutput = 'Input Queue empty.'
end

/*	Use an administrative account. */
execute as login = 'empireelect\aboulanger'

declare
	@CommandOutput varchar(max)

/*	Perform ftp. */
set	@processStep = 0.1
set @command = '\\srvsql2\fx\FxEDI\RawEDIData\CustomerEDI\FTPCommands\ReceiveInbound_v2.cmd'

exec
	FxEDI.EDI.usp_CommandShell_Execute
	@Command = @command
,	@CommandOutput = @CommandOutput out

revert

insert
	FTP.LogDetails
(	FLHRowID
,	Line
,	Command
,	CommandOutput
)
select
	FLHRowID = @fhlRow
,	Line = 1
,	Command = '\\srvsql2\fx\FxEDI\RawEDIData\CustomerEDI\FTPCommands\ReceiveInbound_v2.cmd'
,	CommandOutput = @CommandOutput


/*	Move inbound files to inprocess folder. */
--- <Call>	
set	@CallProcName = 'FS.usp_FileTable_FileMove'
execute
	@ProcReturn = FS.usp_FileTable_FileMove
	    @FromFolder = @inboundFolder
	,	@ToFolder = @inProcessFolder
	,	@FileNamePattern = '%'
	,	@TranDT = @TranDT out
	,	@Result = @ProcResult out

set	@Error = @@Error

if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	goto ERROR_HANDLING
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	goto ERROR_HANDLING
end
if	@ProcResult != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	goto ERROR_HANDLING
end

insert
	FTP.LogDetails
(	FLHRowID
,	Line
,	Command
,	CommandOutput
)
select
	FLHRowID = @fhlRow
,	Line = 2
,	Command = 'FileMove from InBound folder to InProcess folder'
,	CommandOutput = 'Success'
--- </Call>

/*	Copy data from file table into raw XML table.*/
--- <Insert rows="*">
set	@TableName = 'EDI.RawEDIDocuments'

insert
	EDI.EDIDocuments
(	GUID
,	FileName
,	HeaderData
,	Data
,	TradingPartner
,	Type
,	Version
,	EDIStandard
,	Release
,	DocNumber
,	ControlNumber
,	DeliverySchedule
,	MessageNumber
,	SourceType
,	MoparSSDDocument
,	VersionEDIFACTorX12
)
select
	GUID = redInboundFiles.stream_id
,	FileName = redInboundFiles.name
,	HeaderData = red.Data.query('/*[1]/TRN-INFO[1]')
,	Data = red.Data
,	TradingPartner = EDI.udf_EDIDocument_TradingPartner(red.Data)
,	Type = EDI.udf_EDIDocument_Type(red.Data)
,	Version = EDI.udf_EDIDocument_Version(red.Data)
,	EDIStandard =
		case
			when EDI.udf_EDIDocument_TradingPartner(red.Data) LIKE '%Chrysler%' AND EDI.udf_EDIDocument_MoparSSDCRNumberIndicator(red.Data) != 1
				then '00CHRY'
			when EDI.udf_EDIDocument_TradingPartner(red.Data) LIKE '%Ford%' 
				then '00FORD'

			when EDI.udf_EDIDocument_TradingPartner(red.Data) LIKE '%Varroc%' 
				then 'VARROC'
			when EDI.udf_EDIDocument_TradingPartner(red.Data) LIKE '%Stanley Electric%%' 
				then 'STANLEY'
			when EDI.udf_EDIDocument_Version(red.Data) LIKE '%3060%' 
			then '003060' --For Magna PT version
			when EDI.udf_EDIDocument_TradingPartner(red.Data) = 'AutoLiv' 
				then 'AutoLiv'
			when EDI.udf_EDIDocument_TradingPartner(red.Data) LIKE '%ADAC%' 
				then 'ADAC'
			when EDI.udf_EDIDocument_TradingPartner(red.Data) LIKE '%Toyota%' 
				then '00TOYO'
				when EDI.udf_EDIDocument_TradingPartner(red.Data) LIKE '%Dana Corporation%' 
				then
					case
						when EDI.udf_EDIDocument_Type(red.Data) LIKE '[A-Z]%'
							then EDI.udf_EDIDocument_Version(red.data) + coalesce(EDI.udf_EDIDocument_EDIRelease(red.data),EDI.udf_EDIDocument_Version(red.data))
						else EDI.udf_EDIDocument_Version(red.data)
					end
			when EDI.udf_EDIDocument_TradingPartner(red.Data) LIKE '%AZZZZZZZZZZ%' 
				then
					case
						when EDI.udf_EDIDocument_Type(red.Data) LIKE '[A-Z]%'
							then EDI.udf_EDIDocument_Version(red.data) + coalesce(EDI.udf_EDIDocument_EDIRelease(red.data),EDI.udf_EDIDocument_Version(red.data))
						else EDI.udf_EDIDocument_Version(red.data)
					end
			when EDI.udf_EDIDocument_TradingPartner(red.Data) LIKE '%Mazda Corporation%' 
				then '002001'
			when EDI.udf_EDIDocument_MoparSSDCRNumberIndicator(red.Data) = 1
				then 'MOPARSSD'
			else 
			--(CASE WHEN EDI.udf_EDIDocument_Type(Data) LIKE '[A-Z]%' THEN EDI.udf_EDIDocument_Version(red.data)+COALESCE(EDI.udf_EDIDocument_EDIRelease(red.data),EDI.udf_EDIDocument_Version(red.data)) ELSE EDI.udf_EDIDocument_Version(red.data) END) --IConnect writes Release, no need for this case statement
				EDI.udf_EDIDocument_Version(red.Data)
		end
,	Release = EDI.udf_EDIDocument_Release(red.Data)
,	DocNumber = EDI.udf_EDIDocument_DocNumber(red.Data)
,	ControlNumber = EDI.udf_EDIDocument_ControlNumber(red.Data)
,	DeliverySchedule = EDI.udf_EDIDocument_DeliverySchedule(red.Data)
,	MessageNumber = EDI.udf_EDIDocument_MessageNumber(red.Data)
,	SourceType = COALESCE(EDI.udf_EDIDocument_SourceType(red.Data),'')
,	MoparSSDDocument =  COALESCE(EDI.udf_EDIDocument_MoparSSDCRNumberIndicator(red.Data),'')
,	VersionEDIFACTorX12 =
		case
			when EDI.udf_EDIDocument_Type(Data) LIKE '[A-Z]%'
				then EDI.udf_EDIDocument_Version(red.data) + coalesce(EDI.udf_EDIDocument_EDIRelease(red.data),EDI.udf_EDIDocument_Version(red.data))
				else EDI.udf_EDIDocument_Version(red.data)
		end
from
	FxEDI.dbo.RawEDIData redInboundFolder
	join FxEDI.dbo.RawEDIData redInboundFiles
		on redInboundFiles.parent_path_locator = redInboundFolder.path_locator
		and redInboundFiles.is_directory = 0
		and redInboundFiles.name like '%'
	cross apply
		(	select
				Data = convert(xml, redInboundFiles.file_stream)
		) red
where
	redInboundFolder.file_stream.GetFileNamespacePath() = @inProcessFolder
	and redInboundFolder.is_directory = 1

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	goto ERROR_HANDLING
end
--- </Insert>

/*	Move inbound files to archive folder. */
--- <Call>	
set	@CallProcName = 'FS.usp_FileTable_FileMove'
execute
	--@ProcReturn = 
	FS.usp_FileTable_FileMove
	    @FromFolder = @inProcessFolder
	,	@ToFolder = @archiveFolder
	,	@FileNamePattern = '%'
	,	@FileAppendPrefix = @moveFilePrefix
	,	@TranDT = @TranDT out
	,	@Result = @ProcResult out

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	goto ERROR_HANDLING
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	goto ERROR_HANDLING
end
if	@ProcResult != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	goto ERROR_HANDLING
end
--- </Call>
--- </Body>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

--	Error handling
ERROR_HANDLING:

insert
	FTP.LogDetails
(	FLHRowID
,	Line
,	Command
,	CommandOutput
)
select
	FLHRowID = @fhlRow
,	Line = coalesce(-@processStep, -999)
,	Command = coalesce(@command, 'N/A')
,	CommandOutput = coalesce(@ErrorMessage, 'N/A')

/*	Move outbound files to error folder. */
--- <Call>
set	@CallProcName = 'FS.usp_FileTable_FileMove'
execute
	@ProcReturn = FS.usp_FileTable_FileMove
		@FromFolder = @inProcessFolder
	,	@ToFolder = @errorFolder
	,	@FileNamePattern = '%'
	,	@FileAppendPrefix = @moveFilePrefix
	,	@TranDT = @TranDT out
	,	@Result = @ProcResult out

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	raiserror ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	raiserror ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	return	@Result
end
if	@ProcResult != 0 begin
	set	@Result = 900502
	raiserror ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	return	@Result
end
--- </Call>
return

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
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FTP.usp_ReceiveCustomerEDI
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
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

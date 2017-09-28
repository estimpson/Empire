
/*
Create Procedure.FxEDI.FTP.usp_UpdateReceiveFileLogForReplacedBadFile.sql
*/

use FxEDI
go

if	objectproperty(object_id('FTP.usp_UpdateReceiveFileLogForReplacedBadFile'), 'IsProcedure') = 1 begin
	drop procedure FTP.usp_UpdateReceiveFileLogForReplacedBadFile
end
go

create procedure FTP.usp_UpdateReceiveFileLogForReplacedBadFile
	@ReplacedBadFileRowID int
,	@TranDT datetime = null out
,	@Result integer = null out
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FTP.usp_Test
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
/*	Update the receive file log. */
update
	rfl
set	rfl.ReceiveFileGUID =
		(	select top 1
				ed.GUID
			from
				EDI.EDIDocuments ed
			where
				ed.FileName = rfl.SourceFileName
				and ed.RowCreateDT > rfl.SourceFileDT
			order by
				ed.Status desc -- In case file has been replaced.
			,	ed.RowCreateDT asc -- In case a file name gets re-used.
		)
from
	FTP.ReceiveFileLog rfl
where
	rfl.RowID = @ReplacedBadFileRowID

/*	Calculate the CRC32 and FileLength. */
update
	rfl
set	rfl.Status = 2
,	ReceiveFileName = red.name
,	ReceiveCRC32 = convert(varbinary(8), FxUtilities.Fx.FileStreamCRC(red.file_stream))
,	ReceiveFilelength = len(convert(varchar(max), red.file_stream))
from
	FTP.ReceiveFileLog rfl
	join dbo.RawEDIData red
		on red.stream_id = rfl.ReceiveFileGUID
where
	rfl.RowID = @ReplacedBadFileRowID

/*	Update Received Directory Poll */
declare
	@sourceFileDT datetime =
		(	select
				rfl.SourceFileDT
			from
				FTP.ReceiveFileLog rfl
			where
				rfl.RowID = @ReplacedBadFileRowID
		)
	
update
	rdp
set	rdp.ReceivedFileCount = rdpU.ReceivedFileCount
,	rdp.ReceivedCRC32Hash = rdpU.ReceivedCRC32Hash
from
	FTP.ReceivedDirectoryPoll rdp
	cross apply
		(	select
				SourceFileCount = count(rfl.SourceFileName)
			,	ReceivedFileCount = count(rfl.ReceiveFileGUID)
			,	SourceCRC32Hash = checksum_agg(all checksum(rfl.SourceCRC32))
			,	ReceivedCRC32Hash = checksum_agg(all checksum(rfl.ReceiveCRC32))
			from
				FTP.ReceiveFileLog rfl
			where
				rfl.SourceFileDT > rdp.PollWindowBeginDT
				and rfl.SourceFileDT <= rdp.PollWindowEndDT
				and rfl.SourceFileAvailable = 1
		) rdpU
where
	@sourceFileDT > rdp.PollWindowBeginDT
	and @sourceFileDT <= rdp.PollWindowEndDT

/*	Generate an email to notify scheduler. */
declare @html nvarchar(max)

select
	EDI_File_Name = rfl.SourceFileName
,	Original_File_Length = rfl.SourceFileLength
,	File_Date = rfl.SourceFileDT
,	Received_File_Length = rfl.ReceiveFileLength
into
	#BadFileReplaced
from
	FTP.ReceiveFileLog rfl
	join dbo.RawEDIData red
		on red.stream_id = rfl.ReceiveFileGUID
where
	rfl.RowID = @ReplacedBadFileRowID

exec
	FxEDI.FT.usp_TableToHTML
	@tableName = '#BadFileReplaced'
,   @html = @html out

declare
	@EmailBody nvarchar(max)
,   @EmailHeader nvarchar(max) = '(' +
		(	select
				rfl.SourceFileName
			from
				FTP.ReceiveFileLog rfl
			where
				rfl.RowID = @ReplacedBadFileRowID
		) + ') File replaced' 

exec msdb.dbo.sp_send_dbmail
	@profile_name = 'SRVSQL2dBMail'
,   @recipients = 'SQLServeralert@empireelect.com'
,	@copy_recipients = 'spetrovski@empireelect.com;estimpson@fore-thought.com;aboulanger@fore-thought.com;dwest@empireelect.com' -- varchar(max)
,   @subject = @EmailHeader
,   @body = @EmailBody
,   @body_format = 'HTML'
,   @importance = 'High'  -- varchar(6)	
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
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FTP.usp_UpdateReceiveFileLogForReplacedBadFile
	@Param1 = @Param1
,	@TranDT = @TranDT out
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
go



/*
Create Procedure.FxEDI.FTP.usp_RecordReceiveFileLog.sql
*/

use FxEDI
go

if	objectproperty(object_id('FTP.usp_RecordReceiveFileLog'), 'IsProcedure') = 1 begin
	drop procedure FTP.usp_RecordReceiveFileLog
end
go

create procedure FTP.usp_RecordReceiveFileLog
	@RDPFiles xml
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
/*	Parse xml and write Receive File Log. */
insert
	FTP.ReceiveFileLog
(	SourceFileName
,	SourceFileDT
,	SourceFileLength
,	SourceCRC32
,	SourceFileAvailable
)
select
	SourceFileName = rdp.Files.value('@FileName[1]', 'varchar(255)')
,	SourceFileDT = rdp.Files.value('@SourceFileDT[1]', 'datetime')
,	SourceFileLen = rdp.Files.value('@SourceFileLen[1]', 'int')
,	SourceCRC32 = convert(varbinary(8), right('0000000' + rdp.Files.value('@SourceCRC32', 'varchar(8)'), 8), 2)
,	SourceFileAvailable = 1
from
	@RDPFiles.nodes('/Root/File') as rdp(Files)
order by
	2, 1

/*	Update the Receive File Log with filetable GUID of file.*/
update
	rfl
set	rfl.Status = 1
,	rfl.ReceiveFileGUID =
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
	rfl.Status = 0

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
	rfl.Status = 1

/*	Update Received Directory Poll */
declare
	@fromDT datetime
,	@toDT datetime

select
	@fromDT = rdp.Range.value('@FromDT[1]', 'datetime')
,	@toDT = rdp.Range.value('@ToDT[1]', 'datetime')
from
	@RDPFiles.nodes('/Root/Range') as rdp(Range)

update
	rdp
set	rdp.Status = 1
,	rdp.SourceFileCount = rdpU.SourceFileCount
,	rdp.SourceCRC32Hash = rdpU.SourceCRC32Hash
,	rdp.ReceivedFileCount = rdpU.ReceivedFileCount
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
	rdp.ScheduledPollDT between @fromDT and @toDT

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
	@ProcReturn = FTP.usp_RecordReceiveFileLog
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


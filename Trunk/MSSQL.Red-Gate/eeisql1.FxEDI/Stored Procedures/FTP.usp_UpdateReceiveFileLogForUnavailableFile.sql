SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FTP].[usp_UpdateReceiveFileLogForUnavailableFile]
	@UnavailableFileRowID int
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
set	rfl.SourceFileAvailable = 0
from
	FTP.ReceiveFileLog rfl
where
	rfl.RowID = @UnavailableFileRowID

/*	Update Received Directory Poll */
declare
	@sourceFileDT datetime =
		(	select
				rfl.SourceFileDT
			from
				FTP.ReceiveFileLog rfl
			where
				rfl.RowID = @UnavailableFileRowID
		)
	
update
	rdp
set	rdp.SourceFileCount = rdpU.SourceFileCount
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
		) rdpU
where
	@sourceFileDT > rdp.PollWindowBeginDT
	and @sourceFileDT <= rdp.PollWindowEndDT

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
	@ProcReturn = FTP.usp_UpdateReceiveFileLogForUnavailableFile
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
GO

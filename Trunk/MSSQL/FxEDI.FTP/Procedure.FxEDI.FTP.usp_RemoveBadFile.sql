
/*
Create Procedure.FxEDI.FTP.usp_RemoveBadFile.sql
*/

use FxEDI
go

if	objectproperty(object_id('FTP.usp_RemoveBadFile'), 'IsProcedure') = 1 begin
	drop procedure FTP.usp_RemoveBadFile
end
go

create procedure FTP.usp_RemoveBadFile
	@BadFileRowID int
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
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
/*	Delete File (file table row). */
declare
	@FileGUID uniqueidentifier =
		(	select
				rfl.ReceiveFileGUID
			from
				FTP.ReceiveFileLog rfl
			where
				rfl.RowID = @BadFileRowID
		)

delete
	red
from
	dbo.RawEDIData red
where
	red.stream_id = @FileGUID

/*	Mark file as bad/removed from EDI Documents. */
update
	ed
set	ed.Status = -3
from
	EDI.EDIDocuments ed
where
	ed.GUID = @FileGUID
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
	@ProcReturn = FTP.usp_RemoveBadFile
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


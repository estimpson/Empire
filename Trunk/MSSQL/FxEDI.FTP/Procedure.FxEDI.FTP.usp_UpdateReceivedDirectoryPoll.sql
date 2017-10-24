
/*
Create Procedure.FxEDI.FTP.usp_UpdateReceivedDirectoryPoll.sql
*/

use FxEDI
go

if	objectproperty(object_id('FTP.usp_UpdateReceivedDirectoryPoll'), 'IsProcedure') = 1 begin
	drop procedure FTP.usp_UpdateReceivedDirectoryPoll
end
go

create procedure FTP.usp_UpdateReceivedDirectoryPoll
	@TranDT datetime = null out
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
/*	Create new polling records for today and tomorrow. */
declare
	@minuteIncrement int = 30

declare
	@todayDT datetime = dbo.udf_Today()

insert
	FTP.ReceivedDirectoryPoll
(	ScheduledPollDT
,	PollWindowBeginDT
,	PollWindowEndDT
)
select
	rdpNew.ScheduledPollDT
,	rdpNew.PollWindowBeginDT
,	rdpNew.PollWindowEndDT
from
	(	select
			ScheduledPollDT = dateadd(minute, @minuteIncrement * Id, @todayDT)
		,	PollWindowBeginDT = dateadd(minute, @minuteIncrement * (Id - 1), @todayDT)
		,	PollWindowEndDT = dateadd(minute, @minuteIncrement * Id, @todayDT)
		from
			FxUtilities.dbo.IndexTable(1, 48*60/@minuteIncrement) it
	) rdpNew
where
	not exists
		(	select
				rdp.ScheduledPollDT
			from
				FTP.ReceivedDirectoryPoll rdp
			where
				rdp.ScheduledPollDT >= rdpNew.ScheduledPollDT
		)

/*	Calculate source file summary for */

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
	@ProcReturn = FTP.usp_UpdateReceivedDirectoryPoll
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


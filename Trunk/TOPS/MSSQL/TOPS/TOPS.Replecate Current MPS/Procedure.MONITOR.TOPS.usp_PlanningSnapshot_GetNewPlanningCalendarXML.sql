
/*
Create Procedure.MONITOR.TOPS.usp_PlanningSnapshot_GetNewPlanningCalendarXML.sql
*/

use MONITOR
go

if	objectproperty(object_id('TOPS.usp_PlanningSnapshot_GetNewPlanningCalendarXML'), 'IsProcedure') = 1 begin
	drop procedure TOPS.usp_PlanningSnapshot_GetNewPlanningCalendarXML
end
go

create procedure TOPS.usp_PlanningSnapshot_GetNewPlanningCalendarXML
	@ThisMonday datetime
,	@PlanningCalendarXML xml out
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. TOPS.usp_Test
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
/*	Generate calendar. */
declare
	@Calendar table
(	CalendarDT datetime
,	DailyWeekly char(1)
,	WeekNo int
)

insert
	@Calendar
(	CalendarDT
,	DailyWeekly
,	WeekNo
)
select
	CalendarDT = @ThisMonday + ur.RowNumber - 1
,	'D'
,	WeekNo = datediff(day, @ThisMonday, @ThisMonday + ur.RowNumber - 1)/7 + 1
from
	FT.udf_Rows(14) ur
union all
select
	CalendarDT = @ThisMonday + (ur.RowNumber - 1) * 7
,	'W'
,	WeekNo = datediff(day, @ThisMonday, @ThisMonday + (ur.RowNumber - 1) * 7)/7 + 1
from
	FT.udf_Rows(58) ur
where
	ur.RowNumber > 2

set	@PlanningCalendarXML =
	(	select
			*
		from
			@Calendar PC
		for xml auto
	)
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
	@ThisMonday datetime = '2017-12-18'
,	@PlanningCalendarXML xml

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_GetNewPlanningCalendarXML
	@ThisMonday = @ThisMonday
,	@PlanningCalendarXML = @PlanningCalendarXML out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult, @PlanningCalendarXML
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


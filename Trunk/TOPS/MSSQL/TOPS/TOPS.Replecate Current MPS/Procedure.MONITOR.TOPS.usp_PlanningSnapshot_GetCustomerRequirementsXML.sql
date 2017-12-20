
/*
Create Procedure.MONITOR.TOPS.usp_PlanningSnapshot_GetCustomerRequirementsXML.sql
*/

use MONITOR
go

if	objectproperty(object_id('TOPS.usp_PlanningSnapshot_GetCustomerRequirementsXML'), 'IsProcedure') = 1 begin
	drop procedure TOPS.usp_PlanningSnapshot_GetCustomerRequirementsXML
end
go

create procedure TOPS.usp_PlanningSnapshot_GetCustomerRequirementsXML
	@FinishedPart varchar(25)
,	@ThisMonday datetime
,	@LastDaily datetime
,	@PastDT datetime
,	@CustomerRequirementsXML xml out
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
/*	Customer requirements. */
declare
	@CustomerRequirements table
(	DueDT datetime
,	OrderQty numeric(20,6)
,	DailyWeekly char(1)
)

insert
	@CustomerRequirements
(	DueDT
,	OrderQty
,	DailyWeekly
)
select
	loo.DueDT
,	loo.OrderQty
,	DailyWeekly =
		case
			when loo.DueDT < @LastDaily then 'D'
			else 'W'
		end
from
	(	select
			DueDT =
				case
					when loo.DueDT < @ThisMonday then @PastDT
					when loo.DueDT < @LastDaily then loo.DueDT
					else loo.MondayDate
				end
		,	OrderQty = sum(loo.Quantity)
		from
			TOPS.Leg_OpenOrders loo
		where
			loo.Part = @FinishedPart
		group by
			case
				when loo.DueDT < @ThisMonday then @PastDT
				when loo.DueDT < @LastDaily then loo.DueDT
				else loo.MondayDate
			end
		) loo
order by
	1

set @CustomerRequirementsXML =
	(	select
			*
		from
			@CustomerRequirements CR
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
	@FinishedPart varchar(25) = 'ALC0598-HC02'
,	@ThisMonday datetime = '2017-12-18'
,	@LastDaily datetime = '2017-12-31'
,	@PastDT datetime = '2017-12-16'
,	@CustomerRequirementsXML xml

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_GetCustomerRequirementsXML
	@FinishedPart = @FinishedPart
,	@ThisMonday = @ThisMonday
,	@LastDaily = @LastDaily
,	@PastDT = @PastDT
,	@CustomerRequirementsXML = @CustomerRequirementsXML out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult, @CustomerRequirementsXML
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


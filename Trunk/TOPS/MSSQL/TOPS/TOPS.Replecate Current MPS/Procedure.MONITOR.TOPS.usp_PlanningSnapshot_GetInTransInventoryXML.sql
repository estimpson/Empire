
/*
Create Procedure.MONITOR.TOPS.usp_PlanningSnapshot_GetInTransInventoryXML.sql
*/

use MONITOR
go

if	objectproperty(object_id('TOPS.usp_PlanningSnapshot_GetInTransInventoryXML'), 'IsProcedure') = 1 begin
	drop procedure TOPS.usp_PlanningSnapshot_GetInTransInventoryXML
end
go

create procedure TOPS.usp_PlanningSnapshot_GetInTransInventoryXML
	@FinishedPart varchar(25)
,	@InTransInventoryXML xml out
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
/*	In transit inventory. */
declare
	@InTransInventory table
(	InTransDT datetime
,	InTransQty numeric(20,6)
)

insert
	@InTransInventory
(	InTransDT
,	InTransQty
)
select
	lti.InTransDT
,	InTransQty = sum(lti.InTransQty)
from
	TOPS.Leg_TransInventory lti
where
	lti.Part = @FinishedPart
group by
	lti.InTransDT
order by
	lti.InTransDT

set @InTransInventoryXML =
	(	select
			*
		from
			@InTransInventory ITI
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
,	@InTransInventoryXML xml

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_GetInTransInventoryXML
	@FinishedPart = @FinishedPart
,	@InTransInventoryXML = @InTransInventoryXML out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult, @InTransInventoryXML
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


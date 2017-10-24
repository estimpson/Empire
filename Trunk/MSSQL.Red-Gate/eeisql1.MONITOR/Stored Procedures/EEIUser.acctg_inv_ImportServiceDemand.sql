SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[acctg_inv_ImportServiceDemand]
as
declare
	@Result int
,	@TranDT datetime

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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. eeiuser.usp_Test
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
/*	Remove duplicate column names (Service Price).*/
if	objectproperty(object_id('EEIACCT.ServiceDemandForecast'), 'IsTable') is not null begin
	drop table
		EEIACCT.ServiceDemandForecast
end

select
	*
into
	EEIACCT.ServiceDemandForecast
from
	openrowset
		(	'MSDASQL'
		,	'Driver={Microsoft Access Text Driver (*.txt, *.csv)};DefaultDir=C:\Monitor4;'
		,	'select * from ServiceDemand.csv'
		)
where
	[Base Part] not like 'Total %'
order by
	[Base Part]
--- </Body>

if	@TranCount = 0 begin
	commit tran @ProcName
end

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
	@ProcReturn = eeiuser.acctg_inv_ImportServiceDemand
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

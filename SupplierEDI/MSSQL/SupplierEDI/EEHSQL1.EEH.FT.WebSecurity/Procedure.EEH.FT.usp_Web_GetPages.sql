
/*
Create Procedure.EEH.FT.usp_Web_GetPages.sql
*/

use EEH
go

if	objectproperty(object_id('FT.usp_Web_GetPages'), 'IsProcedure') = 1 begin
	drop procedure FT.usp_Web_GetPages
end
go

create procedure FT.usp_Web_GetPages
	@UserCode varchar(50)
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint
set	@TranCount = @@TranCount

--- <SP Begin Logging>
declare
	@LogID int

insert
	FxSYS.USP_Calls
(	USP_Name
,	BeginDT
,	InArguments
)
select
	USP_Name = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
,	BeginDT = getdate()
,	InArguments =
		'@UserCode = ' + coalesce('''' + @UserCode + '''', '<null>')
		+ ', @TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
		+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')

set	@LogID = scope_identity()
--- </SP Begin Logging>

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
select
	wp.PageName
,	wp.FilePath
,	wpu.DefaultPage
from
	FT.WebPages wp
	join FT.WebPagesUsers wpu
		on wpu.PageName = wp.PageName
where
	wpu.[User] = @UserCode
--- </Body>


---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

--- <SP End Logging>
update
	uc
set
	EndDT = getdate()
,	OutArguments =
		'@UserCode = ' + coalesce(@UserCode, '<null>')
		+ ', @TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
		+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')
from
	FXSYS.USP_Calls uc
where
	RowID = @LogID
--- </SP End Logging>

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
	@ProcReturn = dbo.usp_Admin_LoginUser
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


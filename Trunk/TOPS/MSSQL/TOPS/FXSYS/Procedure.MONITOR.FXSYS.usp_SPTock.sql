
/*
Create Procedure.FxSYS.FXSYS.usp_SPTock.sql
*/

use FxSYS
go

if	objectproperty(object_id('FXSYS.usp_SPTock'), 'IsProcedure') = 1 begin
	drop procedure FXSYS.usp_SPTock
end
go

create procedure FXSYS.usp_SPTock
	@StepDescription nvarchar(max)
,	@TicDT datetime
,	@TocDT datetime out
,	@Debug bigint
,	@DebugMsg nvarchar(max) out
as
begin

	--set xact_abort on
	set nocount on

	--- <Error Handling>
	declare
		@ProcName sysname

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. TOPS.usp_Test
	--- </Error Handling>

	/*	Record initial transaction count. */
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount

	begin try
		---	<ArgumentValidation>
		---	</ArgumentValidation>

		--- <Body>
		/*	Calculate the time difference and convert to string. */
		set @TocDT = getdate()
		declare
			@TimeDiff datetime = @TocDT - @TicDT

		declare
			@TimeDiffString nvarchar(max) =
				case
					when datediff(day, @TimeDiff, convert(datetime, '1900-01-01')) > 1
						then convert(nvarchar(max), datediff(day, @TimeDiff, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(nchar(12), @TimeDiff, 114)
					else
						convert(nvarchar(12), @TimeDiff, 114)
				end
		
		set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @StepDescription + ': ' + @TimeDiffString
	end try
	begin catch
		declare
			@errorSeverity int
		,	@errorState int
		,	@errorMessage nvarchar(2048)
		,	@xact_state int
	
		select
			@errorSeverity = error_severity()
		,	@errorState = error_state ()
		,	@errorMessage = error_message()
		,	@xact_state = xact_state()

		execute FXSYS.usp_PrintError

		if	@xact_state = -1 begin 
			rollback
			execute FXSYS.usp_LogError
		end
		if	@xact_state = 1 and @TranCount = 0 begin
			rollback
			execute FXSYS.usp_LogError
		end
		if	@xact_state = 1 and @TranCount > 0 begin
			rollback transaction @ProcName
			execute FXSYS.usp_LogError
		end

		raiserror(@errorMessage, @errorSeverity, @errorState)
	end catch
end
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
	@ProcReturn = FXSYS.usp_SPTock
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


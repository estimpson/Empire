SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [TOPS].[usp_PlanningSnapshot_GetCustomerRequirementsXML]
	@FinishedPart varchar(25)
,	@ThisMonday datetime
,	@LastDaily datetime
,	@PastDT datetime
,	@CustomerRequirementsXML xml out
,	@TranDT datetime = null out
,	@Result integer = null out
,	@Debug int = 0
,	@DebugMsg varchar(max) = null out
as
begin

	--set xact_abort on
	set nocount on

	--- <TIC>
	declare
		@cDebug int = @Debug + 2 -- Child procedure call level

	if	@Debug & 0x01 = 0x01 begin
		declare
			@TicDT datetime = getdate()
		,	@TocDT datetime
		,	@cDebugMsg varchar(max)

		set @DebugMsg = replicate(' -', (@Debug & 0x3E) / 2) + 'Start ' + user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	end
	--- </TIC>

	--- <SP Begin Logging>
	declare
		@LogID int

	insert
		FXSYS.USP_Calls
	(	USP_Name
	,	BeginDT
	,	InArguments
	)
	select
		USP_Name = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	,	BeginDT = getdate()
	,	InArguments =
			'@FinishedPart = ' + FXSYS.fnStringArgument(@FinishedPart)
			+ ', @ThisMonday = ' + FXSYS.fnDateTimeArgument(@ThisMonday)
			+ ', @LastDaily = ' + FXSYS.fnDateTimeArgument(@LastDaily)
			+ ', @PastDT = ' + FXSYS.fnDateTimeArgument(@PastDT)
			+ ', @CustomerRequirementsXML = ' + FXSYS.fnXMLArgument(@CustomerRequirementsXML)
			+ ', @TranDT = ' + FXSYS.fnDateTimeArgument(@TranDT)
			+ ', @Result = ' + FXSYS.fnIntArgument(@Result)
			+ ', @Debug = ' + FXSYS.fnIntArgument(@Debug)
			+ ', @DebugMsg = ' + FXSYS.fnStringArgument(@DebugMsg)

	set	@LogID = scope_identity()
	--- </SP Begin Logging>

	set	@Result = 999999

	--- <Error Handling>
	declare
		@CallProcName sysname
	,	@TableName sysname
	,	@ProcName sysname
	,	@ProcReturn integer
	,	@ProcResult integer
	,	@RowCount integer

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. TOPS.usp_Test
	--- </Error Handling>

	--- <TranCount>
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount
	--- </TranCount>

	begin try
		--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
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
		/*	Customer Requirements. */
		begin
			declare
				@CustomerRequirements table
			(	DueDT datetime
			,	OrderQty numeric(20,6)
			,	DailyWeekly char(1)
			,	WeekNo int
			)

			insert
				@CustomerRequirements
			(	DueDT
			,	OrderQty
			,	DailyWeekly
			,	WeekNo
			)
			select
				loo.DueDT
			,	loo.OrderQty
			,	DailyWeekly =
					case
						when loo.DueDT < @LastDaily then 'D'
						else 'W'
					end
			,	WeekNo = datediff(day, @ThisMonday, loo.DueDT)/7 + 1
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
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = 'Customer Requirements'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			--- </TOC>
		end
		--- </Body>

		---	<CloseTran AutoCommit=Yes>
		if	@TranCount = 0 begin
			commit tran @ProcName
		end
		---	</CloseTran AutoCommit=Yes>

		--- <SP End Logging>
		update
			uc
		set	EndDT = getdate()
		,	OutArguments = 
				'@TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
				+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')
		from
			FXSYS.USP_Calls uc
		where
			uc.RowID = @LogID
		--- </SP End Logging>

		--- <TIC/TOC END>
		if	@Debug & 0x3F = 0x01 begin
			set @DebugMsg = @DebugMsg + char(13) + char(10)
			print @DebugMsg
			print ''
		end
		--- </TIC/TOC END>

		---	<Return>
		set	@Result = 0
		return
			@Result
		--- </Return>
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
	@FinishedPart varchar(25) = 'ALC0598-HC02'
,	@ThisMonday datetime = '2017-12-18'
,	@LastDaily datetime = '2017-12-31'
,	@PastDT datetime = '2017-12-16'
,	@CustomerRequirementsXML xml
,	@Debug int = 3
,	@DebugMsg varchar(max) = null

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
,	@Debug = @Debug
,	@DebugMsg = @DebugMsg out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult, @CustomerRequirementsXML, @DebugMsg
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


/*
Create Procedure.MONITOR.TOPS.usp_PlanningSnapshot_Q_GetHeaderInfo.sql
*/

use MONITOR
go

if	objectproperty(object_id('TOPS.usp_PlanningSnapshot_Q_GetHeaderInfo'), 'IsProcedure') = 1 begin
	drop procedure TOPS.usp_PlanningSnapshot_Q_GetHeaderInfo
end
go

create procedure TOPS.usp_PlanningSnapshot_Q_GetHeaderInfo
	@FinishedPart varchar(25)
,	@Revision char(9)
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
		@cDebug int = @Debug + 2 -- Proc level

	if	@Debug & 0x01 = 0x01 begin
		declare
			@TicDT datetime = getdate()
		,	@TocDT datetime
		,	@TimeDiff varchar(max)
		,	@TocMsg varchar(max)
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
			'@FinishedPart = ' + FXSYS.fnStringArgument(@FinishedPart )
			+ ', @Revision = ' + FXSYS.fnStringArgument(@Revision)
			+ ', @TranDT = ' + FXSYS.fnDateTimeArgument(@TranDT)
			+ ', @Result = ' + FXSYS.fnIntArgument(@Result)
			+ ', @Debug = ' + FXSYS.fnIntArgument(@Debug)
			+ ', @DebugMsg = ' + FXSYS.fnStringArgument(@DebugMsg)

	set	@LogID = scope_identity()
	--- </SP Begin Logging>

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

	/*	Record initial transaction count. */
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount

	begin try

		---	<ArgumentValidation>

		---	</ArgumentValidation>

		--- <Body>
		--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
		if	@TranCount = 0 begin
			begin tran @ProcName
		end
		else begin
			save tran @ProcName
		end
		set	@TranDT = coalesce(@TranDT, GetDate())
		--- </Tran>

		--- <Body>
		/*	Retrieve Planning Calendar and Read Key Dates. */
		begin
			declare
				@pcXML xml

			select top(1)
				@pcXML = pc.CalendarXML
			from
				TOPS.PlanningSnapshotHeaders psh
				join TOPS.PlanningCalendars pc
					on pc.RowGUID = psh.PlanningCalendarGUID
			where
				psh.FinishedPart = @FinishedPart
				and psh.Revision = @Revision
			order by
				psh.RowID

			declare
				@GenerationDT datetime = @pcXML.value('(/PlanningCalendar/KeyDates/KD/@TranDT)[1]', 'datetime')
			,	@ThisMonday datetime = @pcXML.value('(/PlanningCalendar/KeyDates/KD/@ThisMonday)[1]', 'datetime')

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Retrieve Planning Calendar and Read Key Dates'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			--- </TOC>
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
		end

		/*	Retrieve Planning Header Data. */
		begin
			declare
				@psXML xml

			select top(1)
				@psXML = ps.PlanningXML
			from
				TOPS.PlanningSnapshotHeaders psh
				join TOPS.PlanningSnapshots ps
					on ps.RowGUID = psh.PlanningSnapshotGUID
			where
				psh.FinishedPart = @FinishedPart
				and psh.Revision = @Revision
			order by
				psh.RowID
		
			declare
				@StandardPack numeric(20,6) = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@StandardPack)[1]', 'numeric(20,6)')
			,	@DefaultPO int = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@DefaultPO)[1]', 'int')
			,	@SalesPrice numeric(20,6) = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@SalesPrice)[1]', 'numeric(20,6)')
			,	@ABC_Class_1 char(1) = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@ABC_Class_1)[1]', 'char(1)')
			,	@ABC_Class_2 int = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@ABC_Class_2)[1]', 'int')
			,	@EAU_EEI numeric(20,6) = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@EAU_EEI)[1]', 'numeric(20,6)')
			,	@EEH_Capacity numeric(20,6) = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@EEH_Capacity)[1]', 'numeric(20,6)')
			,	@SOP datetime = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@SOP)[1]', 'datetime')
			,	@EOP datetime = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@EOP)[1]', 'datetime')
			,	@CustomerPart varchar(30) = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@CustomerPart)[1]', 'varchar(30)')
			,	@Description varchar(100) = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@Description)[1]', 'varchar(100)')

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Retrieve Planning Header Data'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			--- </TOC>
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
		end

		/*	Return Results. */
		begin
			select
				FinishedPart = @FinishedPart
			,	Revision = @Revision
			,	GenerationDT = @GenerationDT
			,	ThisMonday = @ThisMonday
			,	StandardPack = @StandardPack
			,	DefaultPO = @DefaultPO
			,	SalesPrice = @SalesPrice
			,	ABC_Class_1 = @ABC_Class_1
			,	ABC_Class_2 = @ABC_Class_2
			,	EAU_EEI = @EAU_EEI
			,	EEH_Capacity = @EEH_Capacity
			,	SOP = @SOP
			,	EOP = @EOP
			,	CustomerPart = @CustomerPart
			,	Description = @Description

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Return Results'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			--- </TOC>
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
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
,	@Revision char(9) = '18.02.000'
,	@Debug int = 1
,	@DebugMsg nvarchar(max)

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_Q_GetHeaderInfo
	@FinishedPart = @FinishedPart
,	@Revision = @Revision
,	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Debug = @Debug
,	@DebugMsg = @DebugMsg out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult, @DebugMsg
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


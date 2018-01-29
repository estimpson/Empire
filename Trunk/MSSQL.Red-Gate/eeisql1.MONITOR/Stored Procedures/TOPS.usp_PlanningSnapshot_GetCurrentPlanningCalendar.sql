SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [TOPS].[usp_PlanningSnapshot_GetCurrentPlanningCalendar]
	@PlanningCalendarGuid uniqueidentifier out
,	@ThisMonday datetime out
,	@LastDaily datetime out
,	@PastDT datetime out
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
			'@PlanningCalendarGuid = ' + FXSYS.fnGUIDArgument(@PlanningCalendarGuid)
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
		/*	Generate Important Dates. */
		begin
			declare
				@Today datetime = FT.fn_TruncDate('d', getdate())
			declare
				@WkDay tinyint = datepart(weekday, @Today)
			declare
				@MondayOffset int = -@WkDay + 2
			
			set
				@ThisMonday = @Today + @MondayOffset
			set
				@LastDaily = @ThisMonday + 13
			set
				@PastDT = @ThisMonday - 2

			declare
				@KeyDatesXML xml =
				(	select
						*
					from
						(	select
								[TranDT] = @TranDT
							,	[Today] = @Today
							,	[WkDay] = @WkDay
							,	[MondayOffset] = @MondayOffset
							,	[ThisMonday] = @ThisMonday
							,	[LastDaily] = @LastDaily
							,	[PastDT] = @PastDT
						) KD
					for xml auto
				)

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = 'Generate Important Dates'
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

		/*	Current Calendar Exists? */
		begin
			if	exists
				(	select
						*
					from
						TOPS.PlanningCalendars pc
					where
						pc.MondayDT = @ThisMonday
				) begin

				/*	Return Current Calendar. */
				set	@PlanningCalendarGuid =
					(	select top(1)
							pc.RowGUID
						from
							TOPS.PlanningCalendars pc
						where
							pc.MondayDT = @ThisMonday
						order by
							pc.RowID desc
					)

				--- <TOC>
				if	@Debug & 0x01 = 0x01 begin
					exec FXSYS.usp_SPTock
						@StepDescription = N'Return Current Calendar'
					,	@TicDT = @TicDT
					,	@TocDT = @TocDT out
					,	@Debug = @Debug
					,	@DebugMsg = @DebugMsg out
							
					set @TicDT = @TocDT
				end
				--- </TOC>
				set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
				set @cDebugMsg = null

				goto finished
			end
		end

		/*	Generate Current Calendar. */
		begin
			declare
				@Calendar table
			(	CalendarDT datetime not null
			,	DailyWeekly char(1) not null
			,	WeekNo int not null
			,	Holiday varchar(50) null
			,	EEIContainerDT datetime null
			,	SchedulingDT datetime null
			,	PlanningDays numeric(20,6) null
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

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Generate Current Calendar'
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

		/*	Add Holiday To Planning Calendar. */
		begin
			update
				c
			set	c.Holiday = hs.Holiday
			,	c.EEIContainerDT = hs.EEIContainerDT
			,	c.SchedulingDT = hs.SchedulingDT
			,	c.PlanningDays = hs.PlanningDays
			from
				@Calendar c
				cross apply
					(	select
							hs.Holiday
						,	hs.EEIContainerDT
						,	hs.SchedulingDT
						,	hs.PlanningDays
						from
							TOPS.HolidaySchedule hs
						where
							datediff(week, @ThisMonday, hs.SchedulingDT) + 1 = c.WeekNo
					) hs

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Add Holiday To Planning Calendar'
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

		/*	Create Calendar XML. */
		begin
			declare
				@PlanningCalendarXML xml =
				(	select
						*
					from
						@Calendar Entry
					for xml auto
				)

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Create Calendar XML'
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

		/*	Write Current Calendar XML. */
		begin
			--- <Insert rows="1">
			set	@TableName = 'TOPS.HolidaySchedules'
			
			insert
				TOPS.PlanningCalendars
			(	MondayDT
			,	CalendarXML
			)
			select
				@ThisMonday
			,	CalendarXML =
				(	select
						PlanningCalendar.KeyDates
					,	PlanningCalendar.Calendar
					from
						(	select
								KeyDates = @KeyDatesXML
							,	Calendar = @PlanningCalendarXML
						) PlanningCalendar 
					for xml auto
				)
			
			select
				@RowCount = @@rowcount
            
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				rollback tran @ProcName
				return
			end
			--- </Insert>
			
			set
				@PlanningCalendarGuid =
					(	select top(1)
							pc.RowGUID
						from
							TOPS.PlanningCalendars pc
						where
							pc.RowID = scope_identity()
						order by
							pc.RowID
					)

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Write Current Calendar XML'
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

		finished:
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
	@PlanningCalendarGuid uniqueidentifier
,	@ThisMonday datetime
,	@LastDaily datetime
,	@PastDT datetime
,	@Debug int = 3
,	@DebugMsg varchar(max) = null

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_GetCurrentPlanningCalendar
	@PlanningCalendarGuid = @PlanningCalendarGuid out
,	@ThisMonday = @ThisMonday out
,	@LastDaily = @LastDaily out
,	@PastDT = @PastDT out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Debug = @Debug
,	@DebugMsg = @DebugMsg out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult, @PlanningCalendarGuid, @ThisMonday, @LastDaily, @PastDT, @DebugMsg

select
	*
from
	TOPS.PlanningCalendars pc
where
	pc.RowGUID = @PlanningCalendarGuid
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

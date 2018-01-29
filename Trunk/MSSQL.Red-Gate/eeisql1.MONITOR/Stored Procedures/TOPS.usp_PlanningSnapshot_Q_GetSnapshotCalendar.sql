SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [TOPS].[usp_PlanningSnapshot_Q_GetSnapshotCalendar]
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

		/*	Extract Planning Calendar. */
		begin
			
			declare
				@PlanningTable table
			(	CalendarDT datetime not null
			,	DailyWeekly char(1) not null
			,	WeekNo int not null
			,	Holiday varchar(50) null
			,	EEIContainerDT datetime null
			,	SchedulingDT datetime null
			,	PlanningDays numeric(20,6) null
			,	RowID int not null IDENTITY(1, 1) primary key
			)
			insert
				@PlanningTable
			(	CalendarDT
			,	DailyWeekly
			,	WeekNo
			,	Holiday
			,	EEIContainerDT
			,	SchedulingDT
			,	PlanningDays
			)
			select
				CalendarDT = ce.CalendarEntry.value('(@CalendarDT)[1]', 'datetime')
			,	DailyWeekly = ce.CalendarEntry.value('(@DailyWeekly)[1]', 'char(1)')
			,	WeekNo = ce.CalendarEntry.value('(@WeekNo)[1]', 'int')
			,	Holiday = ce.CalendarEntry.value('(@Holiday)[1]', 'varchar(50)')
			,	EEIContainerDT = ce.CalendarEntry.value('(@EEIContainerDT)[1]', 'datetime')
			,	SchedulingDT = ce.CalendarEntry.value('(@SchedulingDT)[1]', 'datetime')
			,	PlanningDays = ce.CalendarEntry.value('(@PlanningDays)[1]', 'numeric(20,6)')
			from
				@pcXML.nodes('/PlanningCalendar/Calendar/Entry') as ce(CalendarEntry)
			
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Extract Planning Calendar'
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

		/*	Retrieve Planning Snapshot Data. */
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
			
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Retrieve Planning Snapshot Data'
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

		/*	Read Initial Inventory and EAU. */
		begin
			declare
				@InitOnHand numeric(20,6) = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@InitOnHand)[1]', 'numeric(20,6)')
			,	@EAU_EEI numeric(20,6) = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@EAU_EEI)[1]', 'numeric(20,6)')
			,	@ABC_Class_1 tinyint = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@ABC_Class_1)[1]', 'tinyint')
			,	@ABC_Class_2 tinyint = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@ABC_Class_2)[1]', 'tinyint')

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Read Initial Inventory'
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

		/*	Read Customer Releases Data. */
		begin
			declare
				@CustomerReleases table
			(	DueDT datetime
			,	DailyWeekly char(1)
			,	WeekNo int
			,	OrderQty numeric(20,6)
			)

			insert
				@CustomerReleases
			(	DueDT
			,	DailyWeekly
			,	WeekNo
			,	OrderQty
			)
			select
				DueDT = cr.CustomerRelease.value('(@DueDT)[1]', 'datetime')
			,	DailyWeeklyDailyWeekly = cr.CustomerRelease.value('(@DailyWeekly)[1]', 'char(1)')
			,	WeekNo = cr.CustomerRelease.value('(@WeekNo)[1]', 'int')
			,	OrderQty = cr.CustomerRelease.value('(@OrderQty)[1]', 'numeric(20,6)')
			from
				@psXML.nodes('/PlanningSnapshot/CustomerRequirements/CR') as cr(CustomerRelease)

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Read Customer Releases Data'
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

		/*	Read In-Transit Inventory Data. */
		begin
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
				InTransDT = iti.InTransInventory.value('(@InTransDT)[1]', 'datetime')
			,	InTransQty = iti.InTransInventory.value('(@InTransQty)[1]', 'numeric(20,6)')
			from
				@psXML.nodes('/PlanningSnapshot/InTransInventory/ITI') as iti(InTransInventory)
		end

		/*	Read On Order Data. */
		begin
			declare
				@OnOrderEEH table
			(	OrderDT datetime
			,	DailyWeekly char(1)
			,	WeekNo int
			,	OrderQty numeric(20,6)
			)

			insert
				@OnOrderEEH
			(	OrderDT
			,	DailyWeekly
			,	WeekNo
			,	OrderQty
			)
			select
				OrderDT = ooe.OnOrderEEH.value('(@OrderDT)[1]', 'datetime')
			,	DailyWeekly = ooe.OnOrderEEH.value('(@DailyWeekly)[1]', 'char(1)')
			,	WeekNo = ooe.OnOrderEEH.value('(@WeekNo)[1]', 'int')
			,	OrderQty = ooe.OnOrderEEH.value('(@OrderQty)[1]', 'numeric(20,6)')
			from
				@psXML.nodes('/PlanningSnapshot/OnOrderEEH/OOE') as ooe(OnOrderEEH)
		end

		/*	Build Results. */
		begin
			declare
				@ResultSet table
			(	CalendarDT datetime
			,	DailyWeekly char(1)
			,	WeekNo int
			,	Holiday varchar(50)
			,	EEIContainerDT datetime
			,	SchedulingDT datetime
			,	PlanningDays int
			,	CustomerRequirement numeric(20,6)
			,	OverrideCustomerRequirement numeric(20,6)
			,	InTransQty numeric(20,6)
			,	OnOrderEEH numeric(20,6)
			,	NewOnOrderEEH numeric(20,6)
			,	TotalInventory numeric(20,6)
			,	Balance numeric(20,6)
			,	WeeksOnHand numeric(20,6)
			,	WeeksOnHandWarnFlag tinyint
			,	RowID int
			)

			insert
				@ResultSet
			(	CalendarDT
			,	DailyWeekly
			,	WeekNo
			,	Holiday
			,	EEIContainerDT
			,	SchedulingDT
			,	PlanningDays
			,	CustomerRequirement
			,	OverrideCustomerRequirement
			,	InTransQty
			,	OnOrderEEH
			,	NewOnOrderEEH
			,	RowID
			)
			select
				pt.CalendarDT
			,	pt.DailyWeekly
			,	pt.WeekNo
			,	pt.Holiday
			,	pt.EEIContainerDT
			,	pt.SchedulingDT
			,	pt.PlanningDays
			,	CustomerRequirement = coalesce(cr.OrderQty, 0)
			,	OverrideCustomerRequirement = null
			,	InTransQty = coalesce(iti.InTransQty, 0)
			,	OnOrderEEH = coalesce(oee.OrderQty, 0)
			,	NewOnOrderEEH = null
			,	pt.RowID
			from
				@PlanningTable pt
				outer apply
					(	select
							OrderQty = sum(cr.OrderQty)
						from
							@CustomerReleases cr
						where
							cr.DailyWeekly = pt.DailyWeekly
							and
							(	(	cr.DailyWeekly = 'D'
									and cr.DueDT = pt.CalendarDT
								)
								or
								(	cr.DailyWeekly = 'W'
									and cr.WeekNo = pt.WeekNo
								)
							)
						group by
							case
								when cr.DailyWeekly = 'D' then cr.DueDT
							end
						,	case
								when cr.DailyWeekly = 'W' then cr.WeekNo
							end
					) cr
				outer apply
					(	select
					 		InTransQty = sum(iti.InTransQty)
					 	from
					 		@InTransInventory iti
						where
							iti.InTransDT = pt.CalendarDT
					) iti
				outer apply
					(	select
							OrderQty = sum(ooe.OrderQty)
						from
							@OnOrderEEH ooe
						where
							ooe.DailyWeekly = pt.DailyWeekly
							and
							(	(	ooe.DailyWeekly = 'D'
									and ooe.OrderDT = pt.CalendarDT
								)
								or
								(	ooe.DailyWeekly = 'W'
									and ooe.WeekNo = pt.WeekNo
								)
							)
						group by
							case
								when ooe.DailyWeekly = 'D' then ooe.OrderDT
							end
						,	case
								when ooe.DailyWeekly = 'W' then ooe.WeekNo
							end							
					) oee
			order by
				pt.CalendarDT

			/*	Calculate Running Balance and Total Inventory. */
			update
				rs
			set	rs.Balance =
					(	select
							sum(rs2.InTransQty + coalesce(rs2.NewOnOrderEEH, rs2.OnOrderEEH) - coalesce(rs2.OverrideCustomerRequirement, rs2.CustomerRequirement)) + @InitOnHand
						from
							@ResultSet rs2
						where
							rs2.CalendarDT <= rs.CalendarDT
					)
			from
				@ResultSet rs

			update
				rs
			set rs.TotalInventory = rs.Balance - rs.OnOrderEEH
			from
				@ResultSet rs

			/*	Calculate Weeks On Hand. */
			update
				rs
			set	WeeksOnHand = round
					(	Balance /
						nullif
							(	(	select
										sum(coalesce(rs2.OverrideCustomerRequirement, rs2.CustomerRequirement) / 40)
									from
										@ResultSet rs2
									where
										rs2.WeekNo between 1 and 8
								)
							,	0
							)
					,	0
					) / 5.0
			from
				@ResultSet rs
			where
				rs.WeekNo between 1 and 5

			update
				rs
			set	WeeksOnHand = round
					(	Balance /
						nullif
							(	(	select
										avg(nullif(coalesce(rs2.OverrideCustomerRequirement, rs2.CustomerRequirement), 0))
									from
										@ResultSet rs2
									where
										rs2.WeekNo between rs.WeekNo + 1 and rs.WeekNo + 7
								)
							,	0
							)
					,	1
					)
					
			from
				@ResultSet rs
			where
				rs.WeekNo > 5

			update
				rs
			set	rs.WeeksOnHandWarnFlag =
					case
						when rs.WeeksOnHand < @ABC_Class_1 then 1
						when rs.WeeksOnHand > @ABC_Class_2 then 2
						when rs.WeeksOnHand is null then 3
						else 0
					end
			from
				@ResultSet rs

			select
				rs.CalendarDT
			,	rs.DailyWeekly
			,	rs.WeekNo
			,	rs.Holiday
			,	rs.EEIContainerDT
			,	rs.SchedulingDT
			,	rs.PlanningDays
			,	rs.CustomerRequirement
			,	rs.OverrideCustomerRequirement
			,	rs.InTransQty
			,	rs.OnOrderEEH
			,	rs.NewOnOrderEEH
			,	rs.TotalInventory
			,	rs.Balance
			,	rs.WeeksOnHand
			,	rs.WeeksOnHandWarnFlag
			,	rs.RowID
			from
				@ResultSet rs
			
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
	@FinishedPart varchar(25) = 'ADC0103-HF00'
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
	@ProcReturn = TOPS.usp_PlanningSnapshot_Q_GetSnapshotCalendar
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
GO

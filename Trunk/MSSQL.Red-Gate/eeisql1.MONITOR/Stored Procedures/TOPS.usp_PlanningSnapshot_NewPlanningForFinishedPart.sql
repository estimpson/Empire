SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [TOPS].[usp_PlanningSnapshot_NewPlanningForFinishedPart]
	@FinishedPart varchar(25)
,	@ParentHeirarchID hierarchyid
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
			'@FinishedPart = ' + FXSYS.fnStringArgument(@FinishedPart )
			+ ', @ParentHeirarchID = ' + FXSYS.fnHierarchyIDArgument(@ParentHeirarchID)
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
		/*	Get Planning Calendar. */
		begin
			declare
				@PlanningCalendarGuid uniqueidentifier
			,	@ThisMonday datetime
			,	@LastDaily datetime
			,	@PastDT datetime

			--- <Call>	
			set	@CallProcName = 'TOPS.usp_PlanningSnapshot_GetCurrentPlanningCalendar'

			execute @ProcReturn = TOPS.usp_PlanningSnapshot_GetCurrentPlanningCalendar
				@PlanningCalendarGuid = @PlanningCalendarGuid out
			,	@ThisMonday = @ThisMonday out
			,	@LastDaily = @LastDaily out
			,	@PastDT = @PastDT out
			,	@TranDT = @TranDT out
			,	@Result = @Result out
			,	@Debug = @cDebug
			,	@DebugMsg = @cDebugMsg out

			if	@ProcReturn != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
			end
			if	@ProcResult != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
			end
			--- </Call>

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Get Planning Calendar'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Get Header Data. */
		begin
			declare
				@PlanningHeaderXML xml

			--- <Call>	
			set	@CallProcName = 'TOPS.usp_PlanningSnapshot_GetHeaderXML'
			exec @ProcReturn = TOPS.usp_PlanningSnapshot_GetHeaderXML
				@FinishedPart = @FinishedPart
			,	@ThisMonday = @ThisMonday
			,	@PlanningHeaderXML = @PlanningHeaderXML out
			,	@TranDT = @TranDT out
			,	@Result = @ProcResult out
			,	@Debug = @cDebug
			,	@DebugMsg = @cDebugMsg out
	
			if	@ProcReturn != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
			end
			if	@ProcResult != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
			end
			--- </Call>	

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Get Header Data'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Get Customer Requirements. */
		begin
			declare
				@CustomerRequirementsXML xml

			--- <Call>	
			set	@CallProcName = 'TOPS.usp_PlanningSnapshot_GetCustomerRequirementsXML'
	
			execute @ProcReturn = TOPS.usp_PlanningSnapshot_GetCustomerRequirementsXML
					@FinishedPart = @FinishedPart
				,	@ThisMonday = @ThisMonday
				,	@LastDaily = @LastDaily
				,	@PastDT = @PastDT
				,	@CustomerRequirementsXML = @CustomerRequirementsXML out
				,	@TranDT = @TranDT out
				,	@Result = @ProcResult out
				,	@Debug = @cDebug
				,	@DebugMsg = @cDebugMsg out
	
			if	@ProcReturn != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
			end
			if	@ProcResult != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
			end
			--- </Call>

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Get Customer Requirements'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Get In-Transit EEI. */
		begin
			declare
				@InTransInventoryXML xml

			--- <Call>	
			set	@CallProcName = 'TOPS.usp_PlanningSnapshot_GetInTransInventoryXML'

			execute @ProcReturn = TOPS.usp_PlanningSnapshot_GetInTransInventoryXML
					@FinishedPart = @FinishedPart
				,	@ThisMonday = @ThisMonday
				,	@InTransInventoryXML = @InTransInventoryXML out
				,	@TranDT = @TranDT out
				,	@Result = @ProcResult out
				,	@Debug = @cDebug
				,	@DebugMsg = @cDebugMsg out

			if	@ProcReturn != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
			end
			if	@ProcResult != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
			end
			--- </Call>

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Get In-Transit EEI'
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

		/*	Get On-Order EEH. */
		begin
			declare
				@OnOrderEEHXML xml

			--- <Call>	
			set	@CallProcName = 'TOPS.usp_PlanningSnapshot_GetOnOrderXML'

			execute @ProcReturn = TOPS.usp_PlanningSnapshot_GetOnOrderXML
					@FinishedPart = @FinishedPart
				,	@ThisMonday = @ThisMonday
				,	@LastDaily = @LastDaily
				,	@PastDT = @PastDT
				,	@OnOrderEEHXML = @OnOrderEEHXML out
				,	@TranDT = @TranDT out
				,	@Result = @ProcResult out
				,	@Debug = @cDebug
				,	@DebugMsg = @cDebugMsg out
	
			if	@ProcReturn != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
			end
			if	@ProcResult != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
			end
			--- </Call>

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Get On-Order EEH'
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

		/*	Get Holiday Schedule. */
		begin
			declare
				@HolidayScheduleXML xml =
				(	select
						*
					from
						TOPS.HolidaySchedule HS
					for xml auto
				)

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Get Holiday Schedule'
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

		/*	Generate Planning Snapshot XML. */
		begin
			declare
				@PlanningSnapshotXML xml =
				(	select
						PlanningSnapshot.PlanningHeader
					,	PlanningSnapshot.CustomerRequirements
					,	PlanningSnapshot.InTransInventory
					,	PlanningSnapshot.OnOrderEEH
					from
						(	select
								PlanningHeader = @PlanningHeaderXML
							,	CustomerRequirements = @CustomerRequirementsXML
							,	InTransInventory = @InTransInventoryXML
							,	OnOrderEEH = @OnOrderEEHXML
						) PlanningSnapshot
					for xml auto
				)

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Generate Planning Snapshot XML'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Write XML To Table. */
		begin
			declare
				@PartRoot hierarchyid =
				(	select
						min(psh.PlanningSnapshotID)
					from
						TOPS.PlanningSnapshotHeaders psh
					where
						psh.FinishedPart = @FinishedPart
				)
			,	@Revision varchar(25) = right(datepart(yy, getdate()), 2) + '.' + right('0' + convert(varchar(8),datepart(wk, getdate())), 2) + '.000'
			,	@NewPlanningSnapshotID hierarchyid

			if	@PartRoot is null begin
				/*	Create root. */
				declare
					@PriorPartRoot hierarchyid =
					(	select
							min(psh.PlanningSnapshotID)
						from
							TOPS.PlanningSnapshotHeaders psh
						where
							psh.FinishedPart =
								(	select
										max(psh2.FinishedPart)
									from
										TOPS.PlanningSnapshotHeaders psh2
									where
										psh2.FinishedPart < @FinishedPart
								)
					)
				,	@PostPartRoot hierarchyid =
					(	select
							min(psh.PlanningSnapshotID)
						from
							TOPS.PlanningSnapshotHeaders psh
						where
							psh.FinishedPart =
								(	select
										min(psh2.FinishedPart)
									from
										TOPS.PlanningSnapshotHeaders psh2
									where
										psh2.FinishedPart > @FinishedPart
								)
					)

				set	@NewPlanningSnapshotID = hierarchyid::GetRoot().GetDescendant(@PriorPartRoot, @PostPartRoot)
			end
			else begin
				declare
					@PriorChild hierarchyid =
							(	select
									min(psh.PlanningSnapshotID)
								from
									TOPS.PlanningSnapshotHeaders psh
								where
									psh.FinishedPart = @FinishedPart
									and psh.PlanningSnapshotID.GetAncestor(1) = @PartRoot
									and psh.Revision =
										(	select
												max(psh2.Revision)
											from
												TOPS.PlanningSnapshotHeaders psh2
											where
												psh2.FinishedPart = @FinishedPart
												and psh2.PlanningSnapshotID.GetAncestor(1) = @PartRoot
												and psh2.Revision < @Revision
										)
							)
				
				declare
					@PostChild hierarchyid =
							(	select
									min(psh.PlanningSnapshotID)
								from
									TOPS.PlanningSnapshotHeaders psh
								where
									psh.FinishedPart = @FinishedPart
									and psh.PlanningSnapshotID.GetAncestor(1) = @PartRoot
									and psh.Revision =
										(	select
												max(psh2.Revision)
											from
												TOPS.PlanningSnapshotHeaders psh2
											where
												psh2.FinishedPart = @FinishedPart
												and psh2.PlanningSnapshotID.GetAncestor(1) = @PartRoot
												and psh2.Revision > @Revision
										)
							)

				set	@NewPlanningSnapshotID = @PartRoot.GetDescendant(@PriorChild, @PostChild)
			end

			/*	Write Planning Snapshot XML. */
			begin
				set @Debug += 2

				--- <Insert rows="1">
				set	@TableName = 'TOPS.PlanningSnapshots'
				
				insert
					TOPS.PlanningSnapshots
				(	FinishedPart
				,	Revision
				,	PlanningXML
				)
				select
					FinishedPart = @FinishedPart
				,	Revision = @revision
				,	PlanningXML = @PlanningSnapshotXML
				
				select
					@RowCount = @@Rowcount
				
				if	@RowCount != 1 begin
					set	@Result = 999999
					RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				end
				--- </Insert>

				declare
					@PlanningSnapshotGUID uniqueidentifier =
					(	select top(1)
							ps.RowGUID
						from
							TOPS.PlanningSnapshots ps
						where
							ps.RowID = scope_identity()
						order by
							ps.RowID
					)

				--- <TOC>
				if	@Debug & 0x01 = 0x01 begin
					exec FXSYS.usp_SPTock
						@StepDescription = N'Write Planning Snapshot XML'
					,	@TicDT = @TicDT
					,	@TocDT = @TocDT out
					,	@Debug = @Debug
					,	@DebugMsg = @DebugMsg out
									
					set @TicDT = @TocDT
				end
				--- </TOC>
				set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
				set @cDebugMsg = null
				set @Debug -= 2
			end
				
			--- <Insert rows="1">
			set	@TableName = 'TOPS.PlanningSnapshotHeaders'
	
			insert
				TOPS.PlanningSnapshotHeaders
			(	FinishedPart
			,	Revision
			,	PlanningSnapshotID
			,	PlanningCalendarGUID
			,	PlanningSnapshotGUID
			,	HolidayScheduleGUID
			)
			select
				FinishedPart = @FinishedPart
			,	Revision = right(datepart(yy, getdate()), 2) + '.' + right('0' + convert(varchar(8),datepart(wk, getdate())), 2) + '.000'
			,	PlanningSnapshotID = @NewPlanningSnapshotID
			,	PlanningSnapshotXML = @PlanningCalendarGUID
			,	PlanningSnapshotGUID = @PlanningSnapshotGUID
			,	HolidayScheduleGUID = null

			select
				@RowCount = @@Rowcount
	
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Insert>

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Write XML To Table'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
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
,	@ParentHeirarchID hierarchyid
,	@Debug int = 1
,	@DebugMsg varchar(max) = null

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_NewPlanningForFinishedPart
	@FinishedPart = @FinishedPart
,	@ParentHeirarchID = @ParentHeirarchID
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

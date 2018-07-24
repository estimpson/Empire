
/*
Create Procedure.MONITOR.TOPS.usp_PlanningSnapshot_CRUD_NewOnOrderEEH.sql
*/

use MONITOR
go

if	objectproperty(object_id('TOPS.usp_PlanningSnapshot_CRUD_NewOnOrderEEH'), 'IsProcedure') = 1 begin
	drop procedure TOPS.usp_PlanningSnapshot_CRUD_NewOnOrderEEH
end
go

create procedure TOPS.usp_PlanningSnapshot_CRUD_NewOnOrderEEH
	@User varchar(5)
,	@FinishedPart varchar(25)
,	@Revision char(9)
,	@CalendarDT datetime
,	@NewOnOrderEEH numeric(20,6) -- null to remove new quantity
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
			'@User = ' + FXSYS.fnStringArgument(@User)
			+ ', @FinishedPart = ' + FXSYS.fnStringArgument(@FinishedPart )
			+ ', @Revision = ' + FXSYS.fnStringArgument(@Revision)
			+ ', @CalendarDT = ' + FXSYS.fnDateTimeArgument(@CalendarDT)
			+ ', @NewOnOrderEEH = ' + FXSYS.fnNumericArgument(@NewOnOrderEEH)
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
		/*	Retrieve New EEH Planning. */
		begin
			declare
				@nepXML xml

			select top(1)
				@nepXML = nep.NewEEHPlanningXML
			from
				TOPS.PlanningSnapshotHeaders psh
				join TOPS.NewEEHPlanning nep
					on psh.NewEEHPlanningGUID = nep.RowGUID
			where
				psh.FinishedPart = @FinishedPart
				and psh.Revision = @Revision
			order by
				psh.RowID
			
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Retrieve New EEH Planning'
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

		/*	Extract New EEH Planning. */
		begin
			declare
				@NewEEHPlanning table
			(	CalendarDT datetime primary key
			,	OnOrderEEH numeric(20,6) not null
			)
			insert
				@NewEEHPlanning
			(	CalendarDT
			,	OnOrderEEH
			)
			select
				CalendarDT = nep.NewEEHPlanningEntry.value('(@CalendarDT)[1]', 'datetime')
			,	Requirement = nep.NewEEHPlanningEntry.value('(@OnOrderEEH)[1]', 'numeric(20,6)')
			from
				@nepXML.nodes('/NewEEHPlanningEntry') as nep(NewEEHPlanningEntry)

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Extract New EEH Planning'
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

		/*	Insert/Update/Delete On Order EEH*/
		begin
			if	@NewOnOrderEEH is null begin
				--- <Delete rows="*">
				set	@TableName = '@NewEEHPlanning'
				
				delete
					nep
				from
					@NewEEHPlanning nep
				where
					nep.CalendarDT = @CalendarDT
				--- </Delete>
			end
			else if
				exists
					(	select
							*
						from
							@NewEEHPlanning nep
						where
							nep.CalendarDT = @CalendarDT
					) begin
				--- <Update rows="1">
				set	@TableName = '@NewEEHPlanning'
				
				update
					nep
				set
					nep.OnOrderEEH = @NewOnOrderEEH
				from
					@NewEEHPlanning nep
				where
					nep.CalendarDT = @CalendarDT
				
				select
					@RowCount = @@Rowcount
				
				if	@RowCount != 1 begin
					set	@Result = 999999
					RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				end
				--- </Update>			
			end
			else begin
				--- <Insert rows="1">
				set	@TableName = '@NewEEHPlanning'
				
				insert
					@NewEEHPlanning
				(	CalendarDT
				,	OnOrderEEH
				)
				select
					CalendarDT = @CalendarDT
				,	OnOrderEEH = @NewOnOrderEEH
				
				select
					@RowCount = @@Rowcount
				
				if	@RowCount != 1 begin
					set	@Result = 999999
					RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				end
				--- </Insert>
			end

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Insert/Update/Delete Requirement'
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
	
		/*	Regenerate XML. */
		begin
			select
				@nepXML =
				(	select
						NewEEHPlanningEntry.CalendarDT
					,	NewEEHPlanningEntry.OnOrderEEH
					from
						@NewEEHPlanning NewEEHPlanningEntry
					order by
						NewEEHPlanningEntry.CalendarDT
					for xml auto
				)
			
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Regenerate XML'
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

		/*	Remove XML. */
		if	@nepXML is null begin
			if (	select top(1)
			  			psh.NewEEHPlanningGUID
			  		from
			  			TOPS.PlanningSnapshotHeaders psh
					where
						psh.FinishedPart = @FinishedPart
						and psh.Revision = @Revision
					order by
						psh.RowID
			  	) is not null begin
				--- <Delete rows="1">
				set	@TableName = 'TOPS.NewEEHPlanning'
				
				delete
					nep
				from
					TOPS.PlanningSnapshotHeaders psh
					join TOPS.NewEEHPlanning nep
						on psh.NewEEHPlanningGUID = nep.RowGUID
				where
					psh.FinishedPart = @FinishedPart
					and psh.Revision = @Revision
				
				select
					@RowCount = @@Rowcount
				
				if	@RowCount != 1 begin
					set	@Result = 999999
					RAISERROR ('Error deleting from table %s in procedure %s.  Rows deleted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				end
				--- </Delete>

				--- <Update rows="1">
				set	@TableName = 'TOPS.PlanningSnapshotHeaders'
				
				update
					psh
				set
					psh.NewEEHPlanningGUID = null
				from
					TOPS.PlanningSnapshotHeaders psh
				where
					psh.FinishedPart = @FinishedPart
					and psh.Revision = @Revision
				
				select
					@RowCount = @@Rowcount
				
				if	@RowCount != 1 begin
					set	@Result = 999999
					RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				end
				--- </Update>
			end

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Remove XML'
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

		/*	(Re)Write XML. */
		if	@nepXML is not null begin
			if (	select top(1)
			  			psh.NewEEHPlanningGUID
			  		from
			  			TOPS.PlanningSnapshotHeaders psh
					where
						psh.FinishedPart = @FinishedPart
						and psh.Revision = @Revision
					order by
						psh.RowID
			  	) is null begin

				--- <Insert rows="1">
				set	@TableName = 'TOPS.NewEEHPlanning'
				
				insert
					TOPS.NewEEHPlanning
				(	FinishedPart
				,	Revision
				,	NewEEHPlanningXML
				)
				select
					FinishedPart = @FinishedPart
				,	Revision = @Revision
				,	OverrideXML = @nepXML

				select
					@RowCount = @@Rowcount
				
				if	@RowCount != 1 begin
					set	@Result = 999999
					RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				end
				--- </Insert>

				declare
					@NewEEHPlanningGUID uniqueidentifier =
					(	select top(1)
			  				nep.RowGUID
			  			from
			  				TOPS.NewEEHPlanning nep
						where
							nep.RowID = scope_identity()
						order by
							nep.RowID
					)

				--- <Update rows="1">
				set	@TableName = 'TOPS.PlanningSnapshotHeaders'
				
				update
					psh
				set
					psh.NewEEHPlanningGUID = @NewEEHPlanningGUID
				from
					TOPS.PlanningSnapshotHeaders psh
				where
					psh.FinishedPart = @FinishedPart
					and psh.Revision = @Revision
				
				select
					@RowCount = @@Rowcount
				
				if	@RowCount != 1 begin
					set	@Result = 999999
					RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				end
				--- </Update>
				
			end
			else begin
			
				--- <Update rows="1">
				set	@TableName = 'TOPS.PlanningSnapshotHeaders'
				
				update
					nep
				set
					nep.NewEEHPlanningXML = @nepXML
				from
					TOPS.PlanningSnapshotHeaders psh
					join TOPS.NewEEHPlanning nep
						on psh.NewEEHPlanningGUID = nep.RowGUID
				where
					psh.FinishedPart = @FinishedPart
					and psh.Revision = @Revision
				
				select
					@RowCount = @@Rowcount

				if	@RowCount != 1 begin
					set	@Result = 999999
					RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				end
				--- </Update>
			end							

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'(Re)Write XML'
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
	@User varchar(5) = 'ees'
,	@FinishedPart varchar(25) = 'MAG0269-HC01'
,	@Revision char(9) = '18.07.000'
,	@CalendarDT datetime = '2018-02-14 12:00AM'
,	@NewOnOrderEEH numeric(20,6) = null -- null to remove override
,	@Debug int = 1
,	@DebugMsg nvarchar(max)

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_CRUD_NewOnOrderEEH
	@User = @User
,	@FinishedPart = @FinishedPart
,	@Revision = @Revision
,	@CalendarDT = @CalendarDT
,	@NewOnOrderEEH = @NewOnOrderEEH
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	TOPS.PlanningSnapshotHeaders psh
	join TOPS.NewEEHPlanning nep
		on psh.NewEEHPlanningGUID = nep.RowGUID
where
	psh.FinishedPart = @FinishedPart
	and psh.Revision = @Revision

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_Q_GetSnapshotCalendar
	@FinishedPart = @FinishedPart
,	@Revision = @Revision
,	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Debug = @Debug
,	@DebugMsg = @DebugMsg out


set	@CalendarDT = '2018-01-14'
set @NewOnOrderEEH = null

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_CRUD_NewOnOrderEEH
	@User = @User
,	@FinishedPart = @FinishedPart
,	@Revision = @Revision
,	@CalendarDT = @CalendarDT
,	@NewOnOrderEEH = @NewOnOrderEEH
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	TOPS.PlanningSnapshotHeaders psh
	left join TOPS.NewEEHPlanning nep
		on psh.NewEEHPlanningGUID = nep.RowGUID
where
	psh.FinishedPart = @FinishedPart
	and psh.Revision = @Revision
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

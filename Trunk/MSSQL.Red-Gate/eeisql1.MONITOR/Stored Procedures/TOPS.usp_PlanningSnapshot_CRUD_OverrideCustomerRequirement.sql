SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [TOPS].[usp_PlanningSnapshot_CRUD_OverrideCustomerRequirement]
	@User varchar(5)
,	@FinishedPart varchar(25)
,	@Revision char(9)
,	@CalendarDT datetime
,	@NewRequirement numeric(20,6) -- null to remove override
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
			+ ', @NewRequirement = ' + FXSYS.fnNumericArgument(@NewRequirement)
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
		/*	Retrieve Customer Requirement Overrides. */
		begin
			declare
				@croXML xml

			select top(1)
				@croXML = cro.OverrideXML
			from
				TOPS.PlanningSnapshotHeaders psh
				join TOPS.CustomerRequirementOverrides cro
					on psh.CustomerRequirementOverridesGUID = cro.RowGUID
			where
				psh.FinishedPart = @FinishedPart
				and psh.Revision = @Revision
			order by
				psh.RowID
			
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Retrieve Customer Requirement Overrides'
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

		/*	Extract Overrides. */
		begin
			declare
				@Overrides table
			(	CalendarDT datetime primary key
			,	Requirement numeric(20,6) not null
			)
			insert
				@Overrides
			(	CalendarDT
			,	Requirement
			)
			select
				CalendarDT = cro.OverrideEntry.value('(@CalendarDT)[1]', 'datetime')
			,	Requirement = cro.OverrideEntry.value('(@Requirement)[1]', 'numeric(20,6)')
			from
				@croXML.nodes('/OverrideEntry') as cro(OverrideEntry)

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Extract Overrides'
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

		/*	Insert/Update/Delete Requirement*/
		begin
			if	@NewRequirement is null begin
				--- <Delete rows="*">
				set	@TableName = '@Overrides'
				
				delete
					o
				from
					@Overrides o
				where
					o.CalendarDT = @CalendarDT
				--- </Delete>
			end
			else if
				exists
					(	select
							*
						from
							@Overrides o
						where
							o.CalendarDT = @CalendarDT
					) begin
				--- <Update rows="1">
				set	@TableName = '@Overrides'
				
				update
					o
				set
					o.Requirement = @NewRequirement
				from
					@Overrides o
				where
					o.CalendarDT = @CalendarDT
				
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
				set	@TableName = '@Overrides'
				
				insert
					@Overrides
					(	CalendarDT
					,	Requirement
					)
				select
					CalendarDT = @CalendarDT
				,	Requirement = @NewRequirement
				
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
				@croXML =
				(	select
						OverrideEntry.CalendarDT
					,	OverrideEntry.Requirement
					from
						@Overrides OverrideEntry
					order by
						OverrideEntry.CalendarDT
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
		if	@croXML is null begin
			if (	select top(1)
			  			psh.CustomerRequirementOverridesGUID
			  		from
			  			TOPS.PlanningSnapshotHeaders psh
					where
						psh.FinishedPart = @FinishedPart
						and psh.Revision = @Revision
					order by
						psh.RowID
			  	) is not null begin
				--- <Delete rows="1">
				set	@TableName = 'TOPS.CustomerRequirementOverrides'
				
				delete
					cro
				from
					TOPS.PlanningSnapshotHeaders psh
					join TOPS.CustomerRequirementOverrides cro
						on psh.CustomerRequirementOverridesGUID = cro.RowGUID
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
					psh.CustomerRequirementOverridesGUID = null
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
		if	@croXML is not null begin
			if (	select top(1)
			  			psh.CustomerRequirementOverridesGUID
			  		from
			  			TOPS.PlanningSnapshotHeaders psh
					where
						psh.FinishedPart = @FinishedPart
						and psh.Revision = @Revision
					order by
						psh.RowID
			  	) is null begin

				--- <Insert rows="1">
				set	@TableName = 'TOPS.CustomerRequirementOverrides'
				
				insert
					TOPS.CustomerRequirementOverrides
				(	FinishedPart
				,	Revision
				,	OverrideXML
				)
				select
					FinishedPart = @FinishedPart
				,	Revision = @Revision
				,	OverrideXML = @croXML

				select
					@RowCount = @@Rowcount
				
				if	@RowCount != 1 begin
					set	@Result = 999999
					RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				end
				--- </Insert>

				declare
					@CustomerRequirementOverridesGUID uniqueidentifier =
					(	select top(1)
			  				cro.RowGUID
			  			from
			  				TOPS.CustomerRequirementOverrides cro
						where
							cro.RowID = scope_identity()
						order by
							cro.RowID
					)

				--- <Update rows="1">
				set	@TableName = 'TOPS.PlanningSnapshotHeaders'
				
				update
					psh
				set
					psh.CustomerRequirementOverridesGUID = @CustomerRequirementOverridesGUID
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
				set	@TableName = 'TOPS.CustomerRequirementOverrides'
				
				update
					cro
				set
					cro.OverrideXML = @croXML
				from
					TOPS.PlanningSnapshotHeaders psh
					join TOPS.CustomerRequirementOverrides cro
						on psh.CustomerRequirementOverridesGUID = cro.RowGUID
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
,	@FinishedPart varchar(25) = 'CHR0014-HA00'
,	@Revision char(9) = '18.02.000'
,	@CalendarDT datetime = '2018-01-08 12:00AM'
,	@NewRequirement numeric(20,6) = 100 -- null to remove override
,	@Debug int = 1
,	@DebugMsg nvarchar(max)

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_CRUD_OverrideCustomerRequirement
	@User = @User
,	@FinishedPart = @FinishedPart
,	@Revision = @Revision
,	@CalendarDT = @CalendarDT
,	@NewRequirement = @NewRequirement
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	TOPS.PlanningSnapshotHeaders psh
	join TOPS.CustomerRequirementOverrides cro
		on cro.RowGUID = psh.CustomerRequirementOverridesGUID
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


set	@CalendarDT = '2018-01-08'
set @NewRequirement = null

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_CRUD_OverrideCustomerRequirement
	@User = @User
,	@FinishedPart = @FinishedPart
,	@Revision = @Revision
,	@CalendarDT = @CalendarDT
,	@NewRequirement = @NewRequirement
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	TOPS.PlanningSnapshotHeaders psh
	left join TOPS.CustomerRequirementOverrides cro
		on cro.RowGUID = psh.CustomerRequirementOverridesGUID
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
GO

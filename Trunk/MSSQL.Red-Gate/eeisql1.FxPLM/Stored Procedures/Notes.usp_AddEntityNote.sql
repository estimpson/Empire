SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [Notes].[usp_AddEntityNote]
	@UserCode varchar(25)
,	@EntityURI varchar(1000)
,	@SubjectLine varchar(max) = null
,	@Body varchar(max) = null
--,	@ThumbnailImage varbinary(max) = null
,	@ReferencedURI varchar(max) = null
,	@CategoryName varchar(255) = null
,	@ImportanceFlag int = null
,	@PrivacyFlag int = null
,	@ParentNote int = null
,	@NewNoteID int = null out
,	@NewNoteGUID uniqueidentifier = null out
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
			'@UserCode = ' + coalesce('''' + @UserCode + '''', '<null>')
			+ ', @TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
			+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')
			+ ', @Debug = ' + coalesce(convert(varchar, @Debug), '<null>')
			+ ', @DebugMsg = ' + coalesce('''' + @DebugMsg + '''', '<null>')

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

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. Notes.usp_Test
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
		/* Create PLM employee as needed. */
		set @TocMsg = 'Create PLM employee as needed'
		declare
			@EmployeeID int =
			(	select
					max(e.RowID)
				from
					PM.Employees e
				where
					e.MonitorEmployeeCode = @UserCode
			)

		if	@EmployeeID is null begin
			--- <Insert rows="1">
			set	@TableName = 'Contacts.People'
			
			insert
				Contacts.People
			(	FirstName
			,	LastName
			)
			select
				u.FirstName
			,	u.LastName
			from
				NSA.Users u
			where
				u.UserCode = @UserCode
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			end
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Insert>
			declare
				@PersonID int = scope_identity()

			--- <Insert rows="1">
			set	@TableName = 'PM.Employees'
			
			insert
				PM.Employees
			(	Person
			,	MonitorEmployeeCode
			)
			select
				Person = @PersonID
			,	MonitorEmployeeCode = @UserCode

			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			end
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Insert>
			set @EmployeeID = scope_identity()

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			--- </TOC>
		end

		/* Create note category as needed. */
		set @TocMsg = 'Create note category as needed'
		declare
			@CategoryID int =
			(	select
					max(nc.RowID)
				from
					Notes.NoteCategories nc
				where
					nc.Name = @CategoryName
			)

		if	@CategoryID is null
			and @CategoryName is not null begin

			--- <Insert rows="1">
			set	@TableName = 'Notes.NoteCategories'
			
			insert
				Notes.NoteCategories
			(	Name
			)
			select
				Name = @CategoryName

			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			end
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Insert>
			
			set	@CategoryID = scope_identity()

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			--- </TOC>
		end

		/*	Create entity as needed. */
		set @TocMsg = 'Create entity as needed'
		declare
			@EntityGUID uniqueidentifier =
			(	select top(1)
					e.EntityGUID
				from
					Notes.Entities e
				where
					e.EntityURI = @EntityURI
				order by
					e.RowID
			)

		if	@EntityGUID is null
			and @EntityURI > '' begin

			--- <Insert rows="1">
			set	@TableName = 'Notes.Entities'
			
			insert
				Notes.Entities
			(	EntityURI
			)
			select
				EntityURI = @EntityURI

			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				rollback tran @ProcName
				return
			end
			--- </Insert>
			
			set	@EntityGUID =
				(	select top(1)
						e.EntityGUID
					from
						Notes.Entities e
					where
						e.RowID = scope_identity()
					order by
						e.RowID
				)

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			--- </TOC>
		end

		/*	Generate hierarchy of new note. */
		set @TocMsg = 'Generate hierarchy of new note'
		declare
			@hierarchy hierarchyid

		begin
			if	@ParentNote is null begin

				declare
					@entityRowID int

				set	@entityRowID =
					(	select
							e.RowID
						from
							Notes.Entities e
						where
							e.EntityGUID = @EntityGUID
					)

				declare
					@lastNote hierarchyid =
					(	select
							max(n.Hierarchy)
						from
							Notes.Notes n
						where
							n.EntityGUID = @EntityGUID
							and n.Hierarchy.GetAncestor(1) = '/' + convert(varchar(12), @entityRowID) + '/'
					)

				set @hierarchy = convert(hierarchyid, '/' + convert(varchar(12), @entityRowID) + '/').GetDescendant(@lastNote, null)
			end
			else begin
				declare
					@lastChild hierarchyid =
					(	select
							max(n.Hierarchy)
						from
							Notes.Notes n
						where
							n.EntityGUID = @EntityGUID
							and n.Hierarchy.GetAncestor(1) =
								(	select
										n.Hierarchy
									from
										Notes.Notes n
									where
										n.RowID = @ParentNote
								)
					)

				set @hierarchy =
					(	select
							max(n.Hierarchy)
						from
							Notes.Notes n
						where
							n.RowID = @ParentNote
					).GetDescendant(@lastChild, null)
			end

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			--- </TOC>
		end

		/*	Create entity note. */
		set @TocMsg = 'Create entity note'
		begin
			--- <Insert rows="1">
			set	@TableName = 'Notes.Notes'
			
			insert
				Notes.Notes
			(	Author
			,	SubjectLine
			,	Body
			--,	ThumbnailImage
			,	ReferencedURI
			,	Category
			,	ImportanceFlag
			,	PrivacyFlag
			,	EntityGUID
			,	Hierarchy
			,	RowCreateUser
			,	RowModifiedUser
			)
			select
				Author = @EmployeeID
			,	SubjectLine = @SubjectLine
			,	Body = @Body
			--,	ThumbnailImage = @ThumbnailImage
			,	ReferencedURI = @ReferencedURI
			,	Category = @CategoryID
			,	ImportanceFlag = @ImportanceFlag
			,	PrivacyFlag = coalesce(@PrivacyFlag, 0)
			,	EntityGUID = @EntityGUID
			,	Hierarchy = @hierarchy
			,	RowCreateUser = @UserCode
			,	RowModifiedUser = @UserCode
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			end
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Insert>
			set @NewNoteID = scope_identity()
			set @NewNoteGUID =
				(	select
						n.NoteGUID
					from
						Notes.Notes n
					where
						n.RowID = @NewNoteID
				)

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
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

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = Notes.usp_AddEntityNote
	@FinishedPart = @FinishedPart
,	@ParentHeirarchID = @ParentHeirarchID
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

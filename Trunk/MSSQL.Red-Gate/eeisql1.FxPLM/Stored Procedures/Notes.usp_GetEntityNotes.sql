SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [Notes].[usp_GetEntityNotes]
	@UserCode varchar(25)
,	@EntityURI varchar(1000)
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
		/*	Do something. */
		set @TocMsg = 'Do something'
		begin
			/* statements */
			select
				AuthorID = emp.RowID
			,	AuthorUserCode = emp.MonitorEmployeeCode
			,	Author =
				coalesce(p.FirstName + ' ', '')
				+ coalesce(p.MiddleName + ' ', '')
				+ coalesce(p.LastName, '')
			,	n.SubjectLine
			,	n.Body
			,	n.ReferencedURI
			,	CategoryID = n.Category
			,	CategoryName = nc.Name
			,	n.ImportanceFlag
			,	n.PrivacyFlag
			,	Locked =
					case
						when n.PrivacyFlag = 0 then 0
						when n.PrivacyFlag = 1 and emp.MonitorEmployeeCode = @UserCode then 0
						else 1
					end
			,	n.EntityGUID
			,	e.EntityURI
			,	HierarchyURI = n.Hierarchy.ToString()
			,	ValueChange = evc.Type
			,	evc.OldValue
			,	evc.NewValue
			,	n.RowID
			,	n.RowCreateDT
			,	RowCreateUser =
					(	select
							coalesce(p.FirstName + ' ', '')
							+ coalesce(p.MiddleName + ' ', '')
							+ coalesce(p.LastName, '')
						from
							PM.Employees emp
							join Contacts.People p
								on p.RowID = emp.Person
						where
							emp.MonitorEmployeeCode = n.RowCreateUser
					)
			,	n.RowModifiedDT
			,	RowModifiedUser =
					(	select
							coalesce(p.FirstName + ' ', '')
							+ coalesce(p.MiddleName + ' ', '')
							+ coalesce(p.LastName, '')
						from
							PM.Employees emp
							join Contacts.People p
								on p.RowID = emp.Person
						where
							emp.MonitorEmployeeCode = n.RowModifiedUser
					)
			from
				Notes.Notes n
					left join Notes.NoteCategories nc
						on nc.RowID = n.Category
					left join Notes.EntityValueChanges evc
						on evc.NoteID = n.RowID
				join Notes.Entities e
					on e.EntityGUID = n.EntityGUID
				join PM.Employees emp
					join Contacts.People p
						on p.RowID = emp.Person
					on emp.RowID = n.Author
			where
				e.EntityURI like @EntityURI
				and
				(	n.PrivacyFlag = 0
					or emp.MonitorEmployeeCode = @UserCode
				)
			order by
				n.RowCreateDT

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
	@ProcReturn = Notes.usp_GetEntityNotes
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

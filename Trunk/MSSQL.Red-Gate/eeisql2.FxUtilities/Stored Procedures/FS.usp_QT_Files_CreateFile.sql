SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FS].[usp_QT_Files_CreateFile]
	@ParentDirectoryPath sysname
,	@FileName sysname
,	@FileContents varbinary(max)
,	@NewPathLocator hierarchyid = null out
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

	----- <SP Begin Logging>
	--declare
	--	@LogID int

	--insert
	--	FXSYS.USP_Calls
	--(	USP_Name
	--,	BeginDT
	--,	InArguments
	--)
	--select
	--	USP_Name = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	--,	BeginDT = getdate()
	--,	InArguments =
	--		'@Parm = ' + coalesce('''' + @FinishedPart + '''', '<null>')
	--		+ ', @TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
	--		+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')
	--		+ ', @Debug = ' + coalesce(convert(varchar, @Debug), '<null>')
	--		+ ', @DebugMsg = ' + coalesce('''' + @DebugMsg + '''', '<null>')

	--set	@LogID = scope_identity()
	----- </SP Begin Logging>

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

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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
		--else begin
		--	save tran @ProcName
		--end
		set	@TranDT = coalesce(@TranDT, GetDate())
		--- </Tran>

		--- <Body>
		/*	Create file. */
		set @TocMsg = 'Create file'
		begin
			declare
				@pathLocator hierarchyid

			select
				@pathLocator = FxUtilities.FS.udf_QT_Files_GetFilePathLocator(@ParentDirectoryPath)
			
			if	@pathLocator is null
			begin
				set	@Result = 999999
				RAISERROR ('Error in procedure %s.  Unable to locate parent directory: %s', 16, 1, @ProcName, @ParentDirectoryPath)
			end

			--- <Insert rows="1">
			insert
				dbo.QT_Files
			(	file_stream
			,	name
			,	path_locator
			)
			select
				file_stream = @FileContents
			,	name = @FileName
			,	path_locator = @pathLocator
			
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
			
			select
				@NewPathLocator = FxUtilities.FS.udf_QT_Files_GetFilePathLocator(@ParentDirectoryPath + '\' + @FileName)

			if	@NewPathLocator is null
			begin
				set	@Result = 999999
				RAISERROR ('Error in procedure %s.  Unable to locate new file: %s in parent directory: %s', 16, 1, @ProcName, @FileName, @ParentDirectoryPath)
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
		--- </Body>

		---	<CloseTran AutoCommit=Yes>
		if	@TranCount = 0 begin
			commit tran @ProcName
		end
		---	</CloseTran AutoCommit=Yes>

		----- <SP End Logging>
		--update
		--	uc
		--set	EndDT = getdate()
		--,	OutArguments = 
		--		'@TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
		--		+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')
		--from
		--	FXSYS.USP_Calls uc
		--where
		--	uc.RowID = @LogID
		----- </SP End Logging>

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

		--execute FXSYS.usp_PrintError

		if	@xact_state = -1 begin 
			rollback
			--execute FXSYS.usp_LogError
		end
		if	@xact_state = 1 and @TranCount = 0 begin
			rollback
			--execute FXSYS.usp_LogError
		end
		if	@xact_state = 1 and @TranCount > 0 begin
			rollback transaction @ProcName
			--execute FXSYS.usp_LogError
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
	@ParentDirectoryPath sysname = 'Attachments\Quotes'
,	@FileName sysname = 'Test.txt'
,	@FileContents varbinary(max) = convert(varbinary(max), 'testing 1...2...3!!!')
,	@NewPathLocator hierarchyid = null

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_QT_Files_CreateFile
	@ParentDirectoryPath = @ParentDirectoryPath
,	@FileName = @FileName
,	@FileContents = @FileContents
,	@NewPathLocator = @NewPathLocator out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	[@Error] = @Error, [@ProcReturn] = @ProcReturn, [@TranDT] = @TranDT, [@ProcResult] = @ProcResult, [@NewPathLocator] = @NewPathLocator

select
	qf.file_stream.GetFileNamespacePath()
,	convert(varchar(max), qf.file_stream)
,	*
from
	dbo.QT_Files qf
where
	qf.path_locator = @NewPathLocator
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
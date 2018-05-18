SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FS].[usp_QT_Files_DeleteAttachment]
	@QuoteNumber varchar(50)
,	@AttachmentCategory varchar(50)
,	@FileName sysname
,	@PathLocator hierarchyid
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

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FS.usp_Test
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
		/*	Delete attachment file. */
		set @TocMsg = 'Delete attachment file'
		begin
			declare
				@quotesFolderPath sysname = 'Attachments\Quotes'
			declare
				@quoteFolderPath sysname = @quotesFolderPath + '\' + @QuoteNumber
			declare
				@quoteAttachmentFolderPath sysname = @quoteFolderPath + '\' + @AttachmentCategory
			declare
				@quoteAttachmentFilePath sysname = @quoteAttachmentFolderPath + '\' + @FileName

			--- <Call>	
			set	@CallProcName = 'FS.usp_QT_Files_DeleteFile'

			execute @ProcReturn = FS.usp_QT_Files_DeleteFile
				@ParentDirectoryPath = @quoteAttachmentFolderPath
			,	@FileName = @FileName
			,	@PathLocator = @PathLocator
			,	@TranDT = @TranDT output
			,	@Result = @Result output
			,	@Debug = 0
			,	@DebugMsg = @DebugMsg output			
			
			set	@Error = @@Error
			if	@Error != 0 begin
				set	@Result = 900501
				RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
			end
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
			rollback
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
	@QuoteNumber varchar(50) = '525-07'
,	@AttachmentCategory varchar(50) = 'CustomerQuote'
,	@FileName sysname = 'test.txt'
,	@FileContents varbinary(max) = convert(varbinary(max), 'Testing 1...2...3!!!')
,	@NewPathLocator hierarchyid
,	@NewStreamID uniqueidentifier

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FS.usp_QT_Files_WriteAttachment
	@QuoteNumber = @QuoteNumber
,	@AttachmentCategory = @AttachmentCategory
,	@FileName = @FileName
,	@FileContents = @FileContents
,	@NewPathLocator = @NewPathLocator out
,	@NewStreamID = @NewStreamID out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	[@Error] = @Error, [@ProcReturn] = @ProcReturn, [@TranDT] = @TranDT, [@ProcResult] = @ProcResult, [@NewPathLocator] = @NewPathLocator, [@NewStreamID] = @NewStreamID

select
	qf.file_stream.GetFileNamespacePath()
,	convert(varchar(max), qf.file_stream)
,	*
from
	dbo.QT_Files qf
--where
--	qf.path_locator = @NewPathLocator

execute
	@ProcReturn = FS.usp_QT_Files_DeleteAttachment
	@QuoteNumber = @QuoteNumber
,	@AttachmentCategory = @AttachmentCategory
,	@FileName = @FileName
,	@PathLocator = @NewPathLocator
,	@StreamID = @NewStreamID
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	[@Error] = @Error, [@ProcReturn] = @ProcReturn, [@TranDT] = @TranDT, [@ProcResult] = @ProcResult, [@NewPathLocator] = @NewPathLocator, [@NewStreamID] = @NewStreamID

select
	qf.file_stream.GetFileNamespacePath()
,	convert(varchar(max), qf.file_stream)
,	*
from
	dbo.QT_Files qf
--where
--	qf.path_locator = @NewPathLocator
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

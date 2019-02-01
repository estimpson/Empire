SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FxPVQ].[usp_DeletePartVendorQuote] 
	@User varchar(5)
,	@RowID int
,	@AttachmentCategory varchar(50)
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
	,	InArguments = convert
			(	varchar(max)
			,	(	select
						[@User] = @User
					,	[@RowID] = @RowID
					,	[@TranDT] = @TranDT
					,	[@Result] = @Result
					,	[@Debug] = @Debug
					,	[@DebugMsg] = @DebugMsg
					for xml raw			
				)
			)

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

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. NSA.usp_Test
	--- </Error Handling>

	/*	Record initial transaction count. */
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount

	begin try
		---	<ArgumentValidation>
		/*  PartVendorQuote record exists.  */
		if not exists (
				select
					*
				from
					FxPVQ.PartVendorQuotes pvq
				where
					pvq.RowID = @RowID ) begin
				
			--set @Result = -1
			--raiserror ('Record does not exist.  Procedure %s.', 16, 1, @ProcName)
			rollback transaction @ProcName
			return
		end
		---	</ArgumentValidation>


		--- <Body>
		--- If this record has a file attachment, delete it
		declare
			@vendorPartQuoteNumber varchar(50)
		set
			@vendorPartQuoteNumber = 'PVQ_' + convert(varchar, @RowID)

		if exists (
				select
					*
				from
					FxPVQ.PVQ_FileManagement fm
				where
					fm.PartVendorQuoteNumber = @vendorPartQuoteNumber ) begin 
			
			execute
				@ProcReturn = FxPVQ.usp_PVQ_FileManagement_Delete
				@QuoteNumber = @vendorPartQuoteNumber
			,	@AttachmentCategory = @AttachmentCategory
			,	@TranDT = @TranDT out
			,	@Result = @ProcResult out

			set	@Error = @@error

			if (@Error <> 0) begin
				set @Result = -1
				raiserror ('Failed to delete the file attachment.  Procedure %s.', 16, 1, @ProcName)
				rollback transaction @ProcName
				return
			end
		end

		--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
		if	@TranCount = 0 begin
			begin tran @ProcName
		end
		else begin
			save tran @ProcName
		end
		set	@TranDT = coalesce(@TranDT, getdate())
		--- </Tran>


		/*	Delete the PartVendorQuote record. */
		set @TocMsg = 'Delete the PartVendorQuote record.'
		--- <Delete rows="1">
		set	@TableName = 'FxPVQ.PartVendorQuotes'
			
		delete from
			FxPVQ.PartVendorQuotes
		where
			RowID = @RowID

		select
			@Error = @@Error,
			@RowCount = @@Rowcount
			
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
		end
		if	@RowCount != 1 begin
			set	@Result = 999999
			RAISERROR ('Error deleting from table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
			rollback tran @ProcName
		end
		--- </Delete>

			

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
		,	OutArguments = convert
				(	varchar(max)
				,	(	select
							[@TranDT] = @TranDT
						,	[@Result] = @Result
						,	[@DebugMsg] = @DebugMsg
						for xml raw			
					)
				)
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
	@ProcReturn = NSA.usp_SetProductionPO
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

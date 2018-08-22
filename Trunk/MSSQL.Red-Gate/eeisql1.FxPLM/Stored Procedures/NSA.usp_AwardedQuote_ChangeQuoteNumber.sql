SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [NSA].[usp_AwardedQuote_ChangeQuoteNumber]
	@User varchar(5)
,	@OldQuoteNumber varchar(100)
,	@NewQuoteNumber varchar(100)
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
					,	[@OldQuoteNumber] = @OldQuoteNumber
					,	[@NewQuoteNumber] = @NewQuoteNumber
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
		/*	Ensure quote not already awarded. */
		if	exists
			(	select
					*
				from
					NSA.AwardedQuotes aq
				where
					aq.QuoteNumber = @NewQuoteNumber
			) begin
			raiserror ('Error: Quote %s already awarded.', 16, 1, @NewQuoteNumber)
		end
		
		/*	Ensure quote number is valid. */
		if	not exists
			(	select
					*
				from
					NSA.QuoteLog ql
				where
					ql.QuoteNumber = @NewQuoteNumber
			) begin
			raiserror ('Error: Quote %s not found.', 16, 1, @NewQuoteNumber)
		end	
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
		/*	Change the quote number. */
		set @TocMsg = 'Change the quote number'
		begin
			/*	Drop foreign keys. */
			exec FT.sp_DropForeignKeys

			/*	Update all tables. */
			--- <Update rows="1">
			set	@TableName = 'NSA.AwardedQuotes'
			
			update
				aq
			set aq.QuoteNumber = @NewQuoteNumber
			from
				NSA.AwardedQuotes aq
			where
				aq.QuoteNumber = @OldQuoteNumber
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			end
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Update>

			--- <Update rows="0..1">
			set	@TableName = 'NSA.AwardedQuoteComments'
			
			update
				aqc
			set
				aqc.QuoteNumber = @NewQuoteNumber
			from
				NSA.AwardedQuoteComments aqc
			where
				aqc.QuoteNumber = @OldQuoteNumber
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			end
			if	@RowCount > 1 begin
				set	@Result = 999999
				RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 0 or 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Update>

			--- <Update rows="0..1">
			set	@TableName = 'NSA.AwardedQuoteExceptions'
			
			update
				aqe
			set
				aqe.QuoteNumber = @NewQuoteNumber
			from
				NSA.AwardedQuoteExceptions aqe
			where
				aqe.QuoteNumber = @OldQuoteNumber
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			end
			if	@RowCount > 1 begin
				set	@Result = 999999
				RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 0 or 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Update>
			
			--- <Update rows="0..1">
			set	@TableName = 'NSA.AwardedQuoteLogistics'
			
			update
				aql
			set
				aql.QuoteNumber = @NewQuoteNumber
			from
				NSA.AwardedQuoteLogistics aql
			where
				aql.QuoteNumber = @OldQuoteNumber
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			end
			if	@RowCount > 1 begin
				set	@Result = 999999
				RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 0 or 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Update>
			
			--- <Update rows="0..1">
			set	@TableName = 'NSA.AwardedQuoteProductionPOs'
			
			update
				aqppo
			set
				aqppo.QuoteNumber = @NewQuoteNumber
			from
				NSA.AwardedQuoteProductionPOs aqppo
			where
				aqppo.QuoteNumber = @OldQuoteNumber
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			end
			if	@RowCount > 1 begin
				set	@Result = 999999
				RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 0 or 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Update>
			
			--- <Update rows="0..1">
			set	@TableName = 'NSA.AwardedQuoteShipTos'
			
			update
				aqst
			set
				aqst.QuoteNumber = @NewQuoteNumber
			from
				NSA.AwardedQuoteShipTos aqst
			where
				aqst.QuoteNumber = @OldQuoteNumber
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			end
			if	@RowCount > 1 begin
				set	@Result = 999999
				RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 0 or 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Update>
			
			--- <Update rows="0..1">
			set	@TableName = 'NSA.AwardedQuoteToolingPOs'
			
			update
				aqtpo
			set
				aqtpo.QuoteNumber = @NewQuoteNumber
			from
				NSA.AwardedQuoteToolingPOs aqtpo
			where
				aqtpo.QuoteNumber = @OldQuoteNumber
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			end
			if	@RowCount > 1 begin
				set	@Result = 999999
				RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 0 or 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Update>

			/*	Readd foreign keys. */
			exec FT.sp_AddForeignKeys

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
	@OldQuoteNumber varchar(100) = '0002-2'
,	@NewQuoteNumber varchar(100) = '525-07'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = NSA.usp_AwardedQuote_ChangeQuoteNumber
	@OldQuoteNumber = @OldQuoteNumber
,	@NewQuoteNumber = @NewQuoteNumber
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

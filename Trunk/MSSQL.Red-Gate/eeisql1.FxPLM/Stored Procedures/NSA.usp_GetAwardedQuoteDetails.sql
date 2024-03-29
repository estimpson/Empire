SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [NSA].[usp_GetAwardedQuoteDetails]
	@QuoteNumber varchar(100)
,	@AwardDate datetime out
,	@FormOfCommitment varchar(50) out
,	@QuoteReason varchar(25) out
,	@ReplacingBasePart char(7) out
,	@Salesperson varchar(5) out
,	@ProgramManager varchar(5) out
,	@Comments varchar(max) out
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
						[@QuoteNumber] = @QuoteNumber
					,	[@AwardDate] = @AwardDate
					,	[@FormOfCommitment] = @FormOfCommitment
					,	[@QuoteReason] = @QuoteReason
					,	[@ReplacingBasePart] = @ReplacingBasePart
					,	[@Salesperson] = @Salesperson
					,	[@ProgramManager] = @ProgramManager
					,	[@Comments] = @Comments
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
		/*	Ensure quote number is valid. */
		if	not exists
			(	select
					*
				from
					NSA.QuoteLog ql
				where
					ql.QuoteNumber = @QuoteNumber
			) begin
			raiserror ('Error: Quote %s not found.', 16, 1, @QuoteNUmber)
		end	
		---	</ArgumentValidation>
		
		--- <Body>
		/*	Get awarded quote details. */
		set @TocMsg = 'Get awarded quote details'
		begin
			select
				@AwardDate = coalesce(aq.AwardDate, ql.AwardedDate)
			,	@FormOfCommitment = aq.FormOfCommitment
			,	@QuoteReason = aq.QuoteReason --coalesce(aq.QuoteReason, qr.QuoteReasonID)
			,	@ReplacingBasePart = aq.ReplacingBasePart
			,	@Salesperson = coalesce(aq.Salesperson, s.UserCode)
			,	@ProgramManager = coalesce(aq.ProgramManager, pm.UserCode)
			,	@Comments = aq.Comments
			from
				NSA.QuoteLog ql
				left join NSA.QuoteReasons qr
					on qr.QuoteReason = ql.QuoteReason
				left join NSA.AwardedQuotes aq
					on aq.QuoteNumber = ql.QuoteNumber
				outer apply
					(	select top 1
							*
						from
							NSA.Salespeople s
						where
							s.UserInitials = ql.SalesInitials
					) s
				outer apply
					(	select top 1
							*
						from
							NSA.ProgramManagers pm
						where
							pm.UserInitials = ql.ProgramManagerInitials
					) pm
			where
				ql.QuoteNumber = @QuoteNumber

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
							[@AwardDate] = @AwardDate
						,	[@FormOfCommitment] = @FormOfCommitment
						,	[@QuoteReason] = @QuoteReason
						,	[@ReplacingBasePart] = @ReplacingBasePart
						,	[@Salesperson] = @Salesperson
						,	[@ProgramManager] = @ProgramManager
						,	[@Comments] = @Comments
						,	[@TranDT] = @TranDT
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
	@QuoteNumber varchar(100) = '0394-17'
,	@AwardDate datetime
,	@FormOfCommitment varchar(50)
,	@QuoteReason varchar(25)
,	@ReplacingBasePart char(7)
,	@Salesperson varchar(5)
,	@ProgramManager varchar(5)
,	@Comments varchar(max)

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = NSA.usp_GetAwardedQuoteDetails
	@QuoteNumber = @QuoteNumber
,	@AwardDate = @AwardDate out
,	@FormOfCommitment = @FormOfCommitment out
,	@QuoteReason = @QuoteReason out
,	@ReplacingBasePart = @ReplacingBasePart out
,	@Salesperson = @Salesperson out
,	@ProgramManager = @ProgramManager out
,	@Comments = @Comments out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	[@Error] = @Error
,	[@ProcReturn] = @ProcReturn
,	[@TranDT] = @TranDT
,	[@ProcResult] = @ProcResult
,	[@AwardDate] = @AwardDate
,	[@FormOfCommitment] = @FormOfCommitment
,	[@QuoteReason] = @QuoteReason
,	[@ReplacingBasePart] = @ReplacingBasePart
,	[@Salesperson] = @Salesperson
,	[@ProgramManager] = @ProgramManager
,	[@Comments] = @Comments
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

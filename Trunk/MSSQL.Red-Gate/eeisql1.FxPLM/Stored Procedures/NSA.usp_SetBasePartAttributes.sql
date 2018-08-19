SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [NSA].[usp_SetBasePartAttributes]
	@User varchar(5)
,	@QuoteNumber varchar(100)
,	@BasePartFamilyList varchar(400)
--,	@QuoteCustomer char(3)
--,	@ParentCustomer varchar(50)
,	@ProductLine varchar(25)
,	@EmpireMarketSegment varchar(200)
,	@EmpireMarketSubsegment varchar(200)
,	@EmpireApplication varchar(500)
--,	@Salesperson varchar(50)
--,	@AwardDate datetime
--,	@TypeOfAward varchar(50)
,	@EmpireSOP datetime
,	@EmpireEOP datetime
--,	@EmpireMidModelYear datetime
,	@EmpireEOPNote varchar(max)
,	@Comments varchar(max)
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
			'@User = ' + coalesce('''' + @User + '''', '<null>')
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

		/*	Ensure quote is recorded as awarded. */
		if	not exists
			(	select
					*
				from
					NSA.AwardedQuotes aq
				where
					aq.QuoteNumber = @QuoteNumber
			) begin
			raiserror ('Error: Quote %s must be marked as awarded.', 16, 1, @QuoteNUmber)
		end
		---	</ArgumentValidation>

		--- <Body>
		/*	Create new base part entry if needed. */
		set @TocMsg = 'Create new base part entry if needed'
		declare
			@CSMRelease varchar(10) = MONITOR.dbo.fn_ReturnLatestCSMRelease('CSM')

		declare
			@AwardDate datetime
		,	@TypeOfAward varchar(50)
		,	@Salesperson varchar(50)
		
		select
			@AwardDate = aq.AwardDate
		,	@TypeOfAward = aq.FormOfCommitment
		,	@Salesperson = aq.Salesperson
		from
			NSA.AwardedQuotes aq
			join NSA.Users u
				on u.UserCode = aq.Salesperson
		where
			aq.QuoteNumber = @QuoteNumber

		declare
			@BasePart char(7)
		,	@QuoteCustomer char(3)
		,	@SellingPrice numeric(20,6)
		,	@MaterialCost numeric(20,6)

		select
			@BasePart = ql.EEIPartNumber
		,	@QuoteCustomer = ql.Customer
		,	@SellingPrice = ql.QuotePrice
		,	@MaterialCost = ql.StraightMaterialCost
		from
			NSA.QuoteLog ql
		where
			ql.QuoteNumber = @QuoteNumber

		declare
			@ParentCustomer varchar(50)

		select
			@ParentCustomer = coalesce(max(bppcl.ParentCustomer), 'New customer')
		from
			NSA.QuoteLog ql
			left join NSA.BasePartParentCustomerList bppcl
				on bppcl.BasePartCustomer = ql.Customer

		declare
			@IncludeInForecastBit bit = coalesce
				(	(	select top(1)
				 			bpa.IncludeInForecastFlag
				 		from
				 			NSA.BasePartAttributes bpa
							join NSA.QuoteLog ql
								on ql.EEIPartNumber = bpa.BasePart
						where
							ql.QuoteNumber = @QuoteNumber
						order by
							ql.QuoteNumber
				 	)
				,	0
				)

		if	not exists
			(	select
					*
				from
					NSA.QuoteLog ql
					join NSA.BasePartAttributes bpa
						on bpa.BasePart = ql.EEIPartNumber
				where
					ql.QuoteNumber = @QuoteNumber
			)
		begin

			--- <Call>
			set	@CallProcName = 'MONITOR.EEIUser.acctg_csm_sp_insert_new_base_part'
			execute
				@ProcReturn = MONITOR.EEIUser.acctg_csm_sp_insert_new_base_part
					@release_id = @CSMRelease
				,	@base_part = @BasePart
				,	@salesperson = @Salesperson
				,	@date_of_award = @AwardDate
				,	@type_of_award = @TypeOfAward
				,	@family = @BasePartFamilyList
				,	@customer = @QuoteCustomer
				,	@parent_customer = @ParentCustomer
				,	@product_line = @ProductLine
				,	@empire_market_segment = @EmpireMarketSegment
				,	@empire_market_subsegment = @EmpireMarketSubsegment
				,	@empire_application = @EmpireApplication
				,	@empire_sop = @EmpireSOP
				,	@empire_eop = @EmpireEOP
				,	@sp = @SellingPrice
				,	@mc = @MaterialCost
				,	@part_used_for_mc = 'Quote'
				,	@include_in_forecast = @IncludeInForecastBit
				,	@TranDT = @TranDT out
				,	@Result = @ProcResult out
			
			set	@Error = @@Error
			if	@Error != 0 begin
				set	@Result = 900501
				RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
				rollback tran @ProcName
			end
			if	@ProcReturn != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
				rollback tran @ProcName
			end
			if	@ProcResult != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
				rollback tran @ProcName
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

		/*	Log change of entity value(s). */
		set @TocMsg = 'Log change of entity value(s)'
		declare
			@OldEOP datetime =
				(	select
		  				bpa.EmpireEOP
		  			from
		  				NSA.BasePartAttributes bpa
					where
						bpa.BasePart = @BasePart
		  		)
		,	@NewNoteGUID uniqueidentifier

		if	coalesce(@OldEOP, @EmpireEOP) != coalesce(@EmpireEOP, '1900-01-01') begin

			declare
				@EntityURI varchar(1000) = 'EEI/FxPLM/NSA/AwardedQuotes/QuoteNumber=' + @QuoteNumber + '/BasePartAttributes.EmpireEOP'


			--- <Call>
			set	@CallProcName = 'Notes.usp_AddEntityValueChangeNote'
			execute @ProcReturn = Notes.usp_AddEntityValueChangeNote
					@UserCode = @User
				,	@EntityURI = @EntityURI
				,	@Body = @EmpireEOPNote
				,	@OldValueVar = @OldEOP
				,	@NewValueVar = @EmpireEOP
				,	@NewNoteGUID = @NewNoteGUID out
				,	@TranDT = @TranDT out
				,	@Result = @ProcResult out
				,	@Debug = @cDebug
				,	@DebugMsg = @cDebugMsg out
			
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
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Update base part entry. */
		set @TocMsg = 'Update base part entry'
		begin
			declare
				@eopNote varchar(250) = convert(char(36), @NewNoteGUID)

			--- <Call>	
			set	@CallProcName = 'MONITOR.EEIUser.acctg_csm_sp_update_base_part_attributes'
			execute @ProcReturn = MONITOR.EEIUser.acctg_csm_sp_update_base_part_attributes
				@base_part = @BasePart
			,	@release_id = @CSMRelease
			,	@salesperson = @Salesperson
			,	@date_of_award = @AwardDate
			,	@type_of_award = @TypeOfAward
			,	@family = @BasePartFamilyList
			,	@customer = @QuoteCustomer
			,	@parent_customer = @ParentCustomer
			,	@product_line = @ProductLine
			,	@empire_market_segment = @EmpireMarketSegment
			,	@empire_market_subsegment = @EmpireMarketSubsegment
			,	@empire_application = @EmpireApplication
			,	@empire_sop = @EmpireSOP
			,	@empire_eop = @EmpireEOP
			,	@mid_model_year = null
			,	@empire_eop_note = @eopNote
			,	@include_in_forecast = @IncludeInForecastBit
			
			set	@Error = @@Error
			if	@Error != 0 begin
				set	@Result = 900501
				RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
				rollback tran @ProcName
			end
			if	@ProcReturn != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
				rollback tran @ProcName
			end
			if	@ProcResult != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
				rollback tran @ProcName
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

		/*	Update comments. */
		set @TocMsg = 'Update comments'
		begin
			--- <Update rows="1">
			set	@TableName = 'NSA.AwardedQuotes'
			
			update
				aq
			set
				aq.BasePart_User = @User
			,	aq.BasePart_Comments = @Comments
			from
				NSA.AwardedQuotes aq
			where
				aq.QuoteNumber = @QuoteNumber
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
			end
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				rollback tran @ProcName
			end
			--- </Update>
			
			
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
	@ProcReturn = NSA.usp_SetBasePartAttributes
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

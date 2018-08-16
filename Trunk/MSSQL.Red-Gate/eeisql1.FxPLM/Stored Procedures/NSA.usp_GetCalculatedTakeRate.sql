SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [NSA].[usp_GetCalculatedTakeRate]
	@QuoteNumber varchar(100)
--,	@TranDT datetime = null out
--,	@Result integer = null out
--,	@Debug int = 0
--,	@DebugMsg varchar(max) = null out
as
begin

	--set xact_abort on
	set nocount on

	--- <TIC>
	--declare
	--	@cDebug int = @Debug + 2 -- Proc level

	--if	@Debug & 0x01 = 0x01 begin
	--	declare
	--		@TicDT datetime = getdate()
	--	,	@TocDT datetime
	--	,	@TimeDiff varchar(max)
	--	,	@TocMsg varchar(max)
	--	,	@cDebugMsg varchar(max)

	--	set @DebugMsg = replicate(' -', (@Debug & 0x3E) / 2) + 'Start ' + user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	--end
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
			'@QuoteNumber = ' + coalesce('''' + @QuoteNumber + '''', '<null>')
			--+ ', @TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
			--+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')
			--+ ', @Debug = ' + coalesce(convert(varchar, @Debug), '<null>')
			--+ ', @DebugMsg = ' + coalesce('''' + @DebugMsg + '''', '<null>')

	set	@LogID = scope_identity()
	--- </SP Begin Logging>

	--set	@Result = 999999

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

		---	</ArgumentValidation>

		--- <Body>
		--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
		if	@TranCount = 0 begin
			begin tran @ProcName
		end
		else begin
			save tran @ProcName
		end
		--set	@TranDT = coalesce(@TranDT, GetDate())
		--- </Tran>

		--- <Body>
		/*	Return CSM data set. */
		--set @TocMsg = 'Return CSM data set'
		begin

			declare
				@CsmForecastDemand decimal (20,4)
			,	@QtyPer decimal(20,4)
			,	@FamilyAllocation decimal(20,4) 
			,	@QuotedEau decimal(20,4)
			,	@Sop datetime
			,	@SopYear int
			,	@SopMonth int

			select
				@QuotedEau = ql.EAU
			from
				NSA.QuoteLog ql
			where
				ql.QuoteNumber = @QuoteNumber

			select 
				@FamilyAllocation = min(bpm.FamilyAllocation) 
			,	@QtyPer = min(bpm.QtyPer)
			,	@Sop = max(bpm.CSM_SOP)
			from
				NSA.BasePartMnemonics bpm
			where
				bpm.QuoteNumber = @QuoteNumber

			-- Get the first full year of CSM Demand out of all the mnemonics tied to the quote
			set @SopYear = year(@Sop)
			set @SopMonth = month(@Sop)

			if (@SopMonth > 1) begin
				set @SopYear = @SopYear + 1
			end


			select
				@CsmForecastDemand = 
					case
						when @SopYear = 2012 then 
							sum(coalesce(n.[CY 2012], 0))
						when @SopYear = 2013 then 
							sum(coalesce(n.[CY 2013], 0))
						when @SopYear = 2014 then 
							sum(coalesce(n.[CY 2014], 0))
						when @SopYear = 2015 then 
							sum(coalesce(n.[CY 2015], 0))
						when @SopYear = 2016 then 
							sum(coalesce(n.[CY 2016], 0))
						when @SopYear = 2017 then 
							sum(coalesce(n.[CY 2017], 0))
						when @SopYear = 2018 then 
							sum(coalesce(n.[CY 2018], 0))
						when @SopYear = 2019 then 
							sum(coalesce(n.[CY 2019], 0)) 
						when @SopYear = 2020 then 
							sum(coalesce(n.[CY 2020], 0))  
						when @SopYear = 2021 then 
							sum(coalesce(n.[CY 2021], 0))
						when @SopYear = 2022 then 
							sum(coalesce(n.[CY 2022], 0)) 
						when @SopYear = 2023 then 
							sum(coalesce(n.[CY 2023], 0))
						when @SopYear = 2024 then 
							sum(coalesce(n.[CY 2024], 0)) 
						when @SopYear = 2025 then 
							sum(coalesce(n.[CY 2025], 0)) 
						else 0
					end
			from 
				MONITOR.eeiuser.acctg_csm_NAIHS n
				join NSA.BasePartMnemonics bpm
					on bpm.VehiclePlantMnemonic = n.[Mnemonic-Vehicle/Plant]
			where 
				bpm.QuoteNumber = @QuoteNumber
				and n.Release_ID = (select [MONITOR].[dbo].[fn_ReturnLatestCSMRelease] ('CSM') )


			select 
				@QtyPer as QtyPer
			,	@FamilyAllocation as FamilyAllocation
			,	@QuotedEau as QuotedEau
			,	@CsmForecastDemand as CsmForeCastDemand
			,	convert(decimal(10,6), round(@QuotedEau / (@CsmForecastDemand * @QtyPer * @FamilyAllocation),6)) as TakeRate 


			--- <TOC>
			--if	@Debug & 0x01 = 0x01 begin
			--	set @TocDT = getdate()
			--	set @TimeDiff =
			--		case
			--			when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
			--				then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
			--			else
			--				convert(varchar(12), @TocDT - @TicDT, 114)
			--		end
			--	set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
			--	set @TicDT = @TocDT
			--end
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
		--,	OutArguments = 
		--		'@TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
		--		+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')
		from
			FXSYS.USP_Calls uc
		where
			uc.RowID = @LogID
		--- </SP End Logging>

		--- <TIC/TOC END>
		--if	@Debug & 0x3F = 0x01 begin
		--	set @DebugMsg = @DebugMsg + char(13) + char(10)
		--	print @DebugMsg
		--end
		--- </TIC/TOC END>

		---	<Return>
		--set	@Result = 0
		--return
		--	@Result
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
	@ProcReturn = NSA.usp_GetAwardedQuoteCSMData
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

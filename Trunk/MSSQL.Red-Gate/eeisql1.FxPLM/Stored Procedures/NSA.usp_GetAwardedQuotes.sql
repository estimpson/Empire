SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [NSA].[usp_GetAwardedQuotes]
as
begin

	--set xact_abort on
	set nocount on

	--- <SP Begin Logging>
	declare
		@ProcName sysname = object_name(@@procid)

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
	,	InArguments = null

	set	@LogID = scope_identity()
	--- </SP Begin Logging>

	/*	Record initial transaction count. */
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount

	begin try
		--- <Body>
		/*	Get awarded quote production POs. */
		begin
			select
				aqe.QuoteNumber
			,	aqe.BasePart
			,	aqe.ExcelSpreadsheetBasePart
			,	aqe.Salesperson
			,	aqe.ProgramManager
			,	aqe.AwardDate
			,	aqe.FormOfCommitment
			,	aqe.CustomerCommitmentAttachment
			,	aqe.QuoteTrasferMeetingDT
			,	aqe.SalesForecastDT
			,	aqe.BasePartCustomer
			,	aqe.QuoteReason
			,	aqe.ReplacingBasePart
			,	aqe.CustomerPart
			,	aqe.VehiclePlantMnemonic
			,	aqe.Family
			,	aqe.Program
			,	aqe.Vehicle
			,	aqe.EmpireApplication
			,	aqe.BasePartFamily
			,	aqe.EmpireMarketSegment
			,	aqe.EmpireMarketSubsegment
			,	aqe.ProductLine
			,	aqe.EmpireSOP
			,	aqe.EmpireEOP
			,	aqe.EmpireEOPNote
			,	aqe.BasePart_Comments
			,	aqe.SourcePlantRegion
			,	aqe.QtyPer
			,	aqe.TakeRate
			,	aqe.FamilyAllocation
			,	aqe.CSMEAU
			,	aqe.QuoteDate
			,	aqe.QuotedEAU
			,	aqe.MinimumOrderQuantity
			,	aqe.QuotedPrice
			,	aqe.QuotedMaterialCost
			,	aqe.QuotedSales
			,	aqe.QuotedLTA
			,	aqe.PurchaseOrderDate
			,	aqe.CustomerProductionPurchaseOrderNumber
			,	aqe.AlternativeCustomerCommitment
			,	aqe.PurchaseOrderSellingPrice
			,	aqe.PurchaseOrderSOP
			,	aqe.PurchaseOrderEOP
			,	aqe.PurchaseOrderPriceVariace
			,	aqe.CustomerProductionPurchaseOrderComments
			,	aqe.AmortizationAmount
			,	aqe.AmortizationQuantity
			,	aqe.AmortizationPrice
			,	aqe.AmortizationToolingDescription
			,	aqe.AmortizationCAPEXID
			,	aqe.HardToolingAmount
			,	aqe.HardToolingTrigger
			,	aqe.HardToolingDescription
			,	aqe.HardToolingCAPEXID
			,	aqe.AssemblyTesterToolingAmount
			,	aqe.AssemblyTesterToolingTrigger
			,	aqe.AssemblyTesterToolingDescription
			,	aqe.AssemblyTesterToolingCAPEXID
			,	aqe.EmpireFacility
			,	aqe.FreightTerms
			,	aqe.CustomerShipTos
			,	aqe.Comments
			,	aqe.ValidQuoteNumberFlag
			from
				NSA.AwardedQuotesExtended aqe
			order by
				aqe.AwardDate
			,	aqe.QuoteNumber
		end
		--- </Body>

		--- <SP End Logging>
		update
			uc
		set	EndDT = getdate()
		from
			FXSYS.USP_Calls uc
		where
			uc.RowID = @LogID
		--- </SP End Logging>
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
	@ProcReturn = NSA.usp_GetAwardedQuotes
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

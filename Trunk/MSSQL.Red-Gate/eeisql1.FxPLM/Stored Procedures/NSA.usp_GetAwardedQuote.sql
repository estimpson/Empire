SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [NSA].[usp_GetAwardedQuote]
	@QuoteNumber varchar(50)
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
				aq.QuoteNumber
			,	BasePart = ql.EEIPartNumber
			,	ExcelSpreadsheetBasePart = aqe.EmpireBasePart
			,	Salesperson = uSP.UserName
			,	ProgramManager = uPM.UserName
			,	aq.AwardDate
			,	aq.FormOfCommitment
			,	QuoteTrasferMeetingDT = aq.QuoteTransfer_SignOffDT
			,	SalesForecastDT = aq.CSM_SignOffDT
			,	BasePartCustomer = ql.Customer
			,	QuoteReason = aq.QuoteReason
			,	aq.ReplacingBasePart
			,	CustomerPart = ql.CustomerPartNumber
			,	bpm.VehiclePlantMnemonic
			,	bpm.Family
			,	bpm.Program
			,	bpm.Vehicle
			,	bpa.EmpireApplication
			,	bpa.BasePartFamily
			,	bpa.EmpireMarketSegment
			,	bpa.EmpireMarketSubsegment
			,	bpa.ProductLine
			,	bpa.EmpireSOP
			,	bpa.EmpireEOP
			,	bpa.EmpireEOPNote
			,	aq.BasePart_Comments
			,	bpm.SourcePlantRegion
			,	bpm.QtyPer
			,	bpm.TakeRate
			,	bpm.FamilyAllocation
			,	CSMEAU = bpm.EAU
			,	QuoteDate = ql.ReceiptDate
			,	QuotedEAU = ql.EAU
			,	ql.MinimumOrderQuantity
			,	QuotedPrice = ql.QuotePrice
			,	QuotedMaterialCost = ql.StraightMaterialCost
			,	QuotedSales = ql.EAU * ql.QuotePrice
			,	QuotedLTA = ql.LTA
			,	PurchaseOrderDate = aqppo.PurchaseOrderDT
			,	CustomerProductionPurchaseOrderNumber = aqppo.PONumber
			,	aqppo.AlternativeCustomerCommitment
			,	PurchaseOrderSellingPrice = aqppo.SellingPrice
			,	aqppo.PurchaseOrderSOP
			,	aqppo.PurchaseOrderEOP
			,	PurchaseOrderPriceVariace = aqppo.SellingPrice - ql.QuotePrice
			,	CustomerProductionPurchaseOrderComments = aqppo.Comments
			,	aqtpo.AmortizationAmount
			,	aqtpo.AmortizationQuantity
			,	aqtpo.AmortizationPrice
			,	aqtpo.AmortizationToolingDescription
			,	aqtpo.AmortizationCAPEXID
			,	aqtpo.HardToolingAmount
			,	aqtpo.HardToolingTrigger
			,	aqtpo.HardToolingDescription
			,	aqtpo.HardToolingCAPEXID
			,	aqtpo.AssemblyTesterToolingAmount
			,	aqtpo.AssemblyTesterToolingTrigger
			,	aqtpo.AssemblyTesterToolingDescription
			,	aqtpo.AssemblyTesterToolingCAPEXID
			,	aql.EmpireFacility
			,	aql.FreightTerms
			,	aqst.CustomerShipTos
			,	aq.Comments
			,	ValidQuoteNumberFlag = case when ql.QuoteNumber is not null then 1 else 0 end
			from
				NSA.AwardedQuotes aq
					left join NSA.QuoteLog ql
						on ql.QuoteNumber = aq.QuoteNumber
					left join NSA.AwardedQuoteExceptions aqe
						on aqe.QuoteNumber = aq.QuoteNumber
				left join NSA.Users uSP
					on uSP.UserCode = aq.Salesperson
				left join NSA.Users uPM
					on uPM.UserCode = aq.ProgramManager
				outer apply
					(	select
							bpm.QuoteNumber
						,	VehiclePlantMnemonic = replace(Fx.ToList(distinct bpm.VehiclePlantMnemonic), ', ', '/')
						,	BasePart = min(bpm.BasePart)
						,	QtyPer = min(bpm.QtyPer)
						,	TakeRate = min(bpm.TakeRate)
						,	FamilyAllocation = min(bpm.FamilyAllocation)
						,	Platform = replace(Fx.ToList(distinct bpm.Platform), ', ', '/')
						,	Program = replace(Fx.ToList(distinct bpm.Program), ', ', '/')
						,	Vehicle = replace(Fx.ToList(distinct bpm.Vehicle), ', ', '/')
						,	Manufacturer = replace(Fx.ToList(distinct bpm.Manufacturer), ', ', '/')
						,	Family = replace(Fx.ToList(distinct bpm.Family), ', ', '/')
						,	SourcePlant = replace(Fx.ToList(distinct bpm.SourcePlant), ', ', '/')
						,	SourcePlantCountry = replace(Fx.ToList(distinct bpm.SourcePlantCountry), ', ', '/')
						,	SourcePlantRegion = replace(replace(replace(Fx.ToList(distinct bpm.SourcePlantRegion), ', ', '/'), 'North America', 'NA'), 'Greater China', 'China')
						,	CSM_SOP = min(bpm.CSM_SOP)
						,	CSM_EOP = max(bpm.CSM_EOP)
						,	EAU = sum(bpm.EAU)
						from
							NSA.BasePartMnemonics bpm
						where
							bpm.QuoteNumber = aq.QuoteNumber
						group by
							bpm.QuoteNumber
					) bpm
				left join NSA.BasePartAttributes bpa
					on bpa.QuoteNumber = aq.QuoteNumber
				left join NSA.AwardedQuoteProductionPOs aqppo
					on aqppo.QuoteNumber = aq.QuoteNumber
				left join NSA.AwardedQuoteToolingPOs aqtpo
					on aqtpo.QuoteNumber = aq.QuoteNumber
				left join NSA.AwardedQuoteLogistics aql
					on aql.QuoteNumber = aq.QuoteNumber
				outer apply
					(	select
							CustomerShipTos = replace(Fx.ToList(aqst.CustomerShipTo), ', ', '/')
						from
							NSA.AwardedQuoteShipTos aqst
						where
							aqst.QuoteNumber = aq.QuoteNumber
					) aqst
				where
					aq.QuoteNumber = @QuoteNumber
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
	@ProcReturn = NSA.usp_GetAwardedQuote
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
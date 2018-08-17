SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[AwardedQuotesExtended]
as
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
GO

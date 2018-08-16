SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[NewSalesAwardSetups]
as
select
	EmpireBasePartCode = ebp.BasePartCode
,	nsa.EmpireBasePart
,	SalespersonName = s.Name
,	nsa.Salesperson
,	ProgramManagerName = pm.Name
,	nsa.ProgramManager
,	nsa.ProgramAwardDate
,	nsa.QuoteTransferMeetingFlag
,	nsa.CustomerCommitmentForm
,	nsa.MasterSalesForecastDate
,	CustomerCode = c.Code
,	nsa.Customer
,	NewBusinessTypeName = nbt.Name
,	nsa.NewBusinessType
,	nsa.CustomerPartNumber
,	nsa.Family
,	nsa.VehicleProgram
,	nsa.VehicleName
,	nsa.VehicleApplication
,	nsa.EmpireMarketSegment
,	nsa.EmpireMarketSubsegment
,	ProductLineName = pl.Name
,	nsa.ProductLine
,	GeographicMarketName = gm.Name
,	nsa.GeographicMarket
,	nsa.QtyPerVehicle
,	nsa.TakeRate
,	nsa.FamilyAllocation
,	nsa.CSM_EAU
,	nsa.CustomerAnnualCapacityPlanningVolume
,	nsa.QuoteID
,	nsa.QuoteNumber
,	nsa.QuoteDate
,	nsa.QuotedEAU
,	nsa.MinimumOrderQuantity
,	nsa.QuotedSellingPrice
,	nsa.QuotedMaterialCost
,	nsa.QuotedAnnualSales
,	nsa.QuotedLTACommitment
,	nsa.QuoteNote
,	nsa.CustomerProductionPONumber
,	nsa.ProductionPODate
,	AlternativeCustomerCommitmentName = acc.Name
,	nsa.AlternativeCustomerCommitment
,	nsa.PurchaseOrderSellingPrice
,	nsa.SOPDate
,	nsa.EOPDate
,	nsa.ProductionNote
,	nsa.QuotePurchaseOrderPriceVariance
,	nsa.ToolingPONumber
,	nsa.ToolingPODate
,	nsa.ToolingPOAmount
,	nsa.ToolingPONote
,	nsa.CrimpDiePOFlag
,	nsa.CrimpDiePOAmount
,	nsa.CrimpDiePONote
,	nsa.AmortizationFlag
,	nsa.AmortizationAmount
,	nsa.AmortizationNote
,	nsa.BillingTriggerAndInstallments
,	nsa.ToolingDescription
,	nsa.BudgetCapexID
,	nsa.EmpireFacility
,	nsa.FreightTerms
,	nsa.CustomerShipToLocation
,	nsa.GeneralNote
,	nsa.RowID
from
	NSA.NewSalesAwards nsa
	left join NSA.AlternativeCustomerCommitments acc
		on acc.RowID = nsa.AlternativeCustomerCommitment
	left join NSA.Customers c
		on c.RowID = nsa.Customer
	left join NSA.EmpireBaseParts ebp
		on ebp.RowID = nsa.EmpireBasePart
	left join NSA.GeographicMarkets gm
		on gm.RowID = nsa.GeographicMarket
	left join NSA.NewBusinessTypes nbt
		on nbt.RowID = nsa.NewBusinessType
	left join NSA.ProductLines pl
		on pl.RowID = nsa.ProductLine
	left join NSA.ProgramManagers pm
		on pm.RowID = nsa.ProgramManager
	left join NSA.Salespeople s
		on s.RowID = nsa.Salesperson
GO

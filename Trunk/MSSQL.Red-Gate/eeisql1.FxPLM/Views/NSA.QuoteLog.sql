SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[QuoteLog]
as
select
	qql.QuoteNumber
,	qql.Status
,	qql.Type
,	qql.ParentQuoteID
,	qql.CustomerRFQNumber
,	qql.ReceiptDate
,	qql.Customer
,	qql.RequestedDueDate
,	qql.EEIPromisedDueDate
,	qql.CustomerPartNumber
,	qql.EEIPartNumber
,	qql.Requote
,	qql.Notes
,	qql.EAU
,	qql.ApplicationName
,	qql.ApplicationCode
,	qql.FunctionName
,	qql.Program
,	qql.OEM
,	qql.Nameplate
,	qql.ModelYear
,	qql.SOP
,	qql.EOP
,	qql.SalesInitials
,	qql.ProgramManagerInitials
,	qql.EngineeringInitials
,	qql.LTAPercentage
,	qql.LTAYears
,	qql.EngineeringMaterialsInitials
,	qql.EngineeringMaterialsDate
,	qql.QuoteReviewInitials
,	qql.QuoteReviewDate
,	qql.QuotePricingInitials
,	qql.QuotePricingDate
,	qql.CustomerQuoteInitials
,	qql.CustomerQuoteDate
,	qql.StraightMaterialCost
,	qql.QuotePrice
,	qql.TotalQuotedSales
,	qql.QuoteStatus
,	qql.Awarded
,	qql.AwardedDate
,	qql.ProductionLevel
,	qql.RevLevel
,	qql.ProductionMaterialRollup
,	qql.EmpireMarketSegment
,	qql.EmpireMarketSubsegment
,	qql.RowID
,	qql.RowCreateDT
,	qql.RowCreateUser
,	qql.RowModifiedDT
,	qql.RowModifiedUser
,	qql.Tooling
,	qql.ProgramComputed
,	qql.OEMComputed
,	qql.NameplateComputed
,	qql.PrototypePrice
,	qql.LTA
,	qql.PrintFilePath
,	qql.PrintNo
,	qql.PrintDate
,	qql.CustomerQuoteFilePath
,	qql.StdHours
,	qql.PackageNumber
,	qql.NumberOfDaysLate
,	qql.ProductLine
,	qql.QuoteReason
,	qql.FileServerQuotePrint
,	qql.FileServerCustomerQuote
,	qql.MinimumOrderQuantity
from
	MONITOR.EEIUser.QT_QuoteLog qql
GO

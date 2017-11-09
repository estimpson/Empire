SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_GetQuoteDetails]
	@QuoteNumber varchar(50)
as
set nocount on
set ansi_warnings on


--- <Body>
select
	QuoteNumber
,	coalesce(Customer, '') as Customer
,	coalesce(CustomerRFQNumber, '') as CustomerRFQNumber
,	coalesce(CustomerPartNumber, '') as CustomerPartNumber
,	coalesce(EEIPartNumber, '') as EEIPartNumber
,	coalesce(ModelYear, '') as ModelYear
,	coalesce(Requote, '') as Requote
,	coalesce(StraightMaterialCost, 0) as StraightMaterialCost
,	coalesce(StdHours, 0) as StdHours
,	coalesce(Tooling, 0) as Tooling
,	coalesce(QuotePrice, 0) as QuotePrice
,	coalesce(PrototypePrice, 0) as PrototypePrice
,	case
		when coalesce(SOP, '') = '' then '' 
		else convert(varchar, convert(date, SOP)) 
	end as SOP
,	convert(varchar, convert(date, ReceiptDate)) as ReceiptDate
,	convert(varchar, convert(date, RequestedDueDate)) as RequestedDueDate
,	convert(varchar, convert(date, EEIPromisedDueDate)) as EEIPromisedDueDate
,	coalesce([OEM], '') as [OEM]
,	coalesce(ApplicationCode, '') as ApplicationCode
,	coalesce(ApplicationName, '') as ApplicationName
,	coalesce(FunctionName, '') as FunctionName
,	coalesce(EAU, '') as EAU
,	coalesce(Awarded, '') as Awarded
,	coalesce(Program, '') as Program
,	coalesce(Nameplate, '') as Nameplate
,	coalesce(PackageNumber, '') as PackageNumber
,	case
		when coalesce(EOP, '') = '' then ''
		else convert(varchar, convert(date, EOP)) 
	end as EOP
,	coalesce(ProgramManagerInitials, '') as ProgramManagerInitials
,	coalesce(EngineeringInitials, '') as EngineeringInitials
,	coalesce(SalesInitials, '') as SalesInitials
,	coalesce(EngineeringMaterialsInitials, '') as EngineeringMaterialsInitials
,	case
		when coalesce(EngineeringMaterialsDate, '') = '' then ''
		else convert(varchar, convert(date, EngineeringMaterialsDate)) 
	end as EngineeringMaterialsDate	
,	coalesce(QuoteReviewInitials, '') as QuoteReviewInitials
,	case
		when coalesce(QuoteReviewDate, '') = '' then ''
		else convert(varchar, convert(date, QuoteReviewDate)) 
	end as QuoteReviewDate
,	coalesce(QuotePricingInitials, '') as QuotePricingInitials
,	case
		when coalesce(QuotePricingDate, '') = '' then ''
		else convert(varchar, convert(date, QuotePricingDate)) 
	end as QuotePricingDate
,	coalesce(CustomerQuoteInitials, '') as CustomerQuoteInitials
,	case
		when coalesce(CustomerQuoteDate, '') = '' then ''
		else convert(varchar, convert(date, CustomerQuoteDate)) 
	end as CustomerQuoteDate
,	coalesce(Notes, '') as Notes
from
	EEIUser.QT_QuoteLog ql
where
	ql.QuoteNumber = @QuoteNumber
--- </Body>
GO

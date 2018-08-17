SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[BasePartAttributes]
as
select
	aq.QuoteNumber
,	BasePart = acbpa.base_part
,	BasePartFamily = acbpa.family
,	BasePartCustomer = acbpa.customer
,	ParentCustomer = acbpa.parent_customer
,	ProductLine = acbpa.product_line
,	EmpireMarketSegment = acbpa.empire_market_segment
,	EmpireMarketSubsegment = acbpa.empire_market_subsegment
,	EmpireApplication = acbpa.empire_application
,	EmpireSOP = acbpa.empire_sop
,	EmpireEOP = acbpa.empire_eop
,	IncludeInForecastFlag = acbpa.include_in_forecast
,	SalesPerson = acbpa.Salesperson
,	AwardDate = acbpa.date_of_award
,	CustomerCommitmentForm = acbpa.type_of_award
,	MidModelYear = acbpa.mid_model_year
,	EmpireEOPNote = acbpa.empire_eop_note
,	VerifiedEOP = acbpa.verified_eop
,	VerifiedEOPDate = acbpa.verified_eop_date
,	Comments = aq.BasePart_Comments
from
	MONITOR.EEIUser.acctg_csm_base_part_attributes acbpa
	join NSA.AwardedQuotes aq
		join NSA.QuoteLog ql
			on ql.QuoteNumber = aq.QuoteNumber
		on ql.EEIPartNumber = acbpa.base_part
where
	acbpa.release_id = MONITOR.dbo.fn_ReturnLatestCSMRelease('CSM')
GO

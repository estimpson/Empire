SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[AwardedQuoteToolingPO_AmortizationFlagList]
as
select
	AmortizationFlag = null
,	FlagDescription = 'TBD'
union all
select
	AmortizationFlag = -1
,	FlagDescription = 'N/A'
union all
select
	AmortizationFlag = 0
,	FlagDescription = 'No'
union all
select
	AmortizationFlag = 1
,	FlagDescription = 'Yes'
GO

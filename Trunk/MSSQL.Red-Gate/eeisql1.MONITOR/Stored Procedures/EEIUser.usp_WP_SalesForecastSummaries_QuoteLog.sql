SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_QuoteLog]
	@Filter varchar(50)
,	@FilterValue varchar(250)
as
set nocount on
set ansi_warnings on


--- <Body>
select
	QuoteNumber
,	Customer
,	Program
,	EEIPartNumber
,	Nameplate
,	ReceiptDate
,	SOP
,	EOP
,	QuoteStatus
,	Awarded
,	SalesPerMonth_2016 as Sales_2016
,	SalesPerMonth_2017 as Sales_2017
,	SalesPerMonth_2018 as Sales_2018
,	SalesPerMonth_2019 as Sales_2019
,	SalesPerMonth_2020 as Sales_2020
,	SalesPerMonth_2021 as Sales_2021
,	SalesPerMonth_2022 as Sales_2022
,	(SalesPerMonth_2017 - SalesPerMonth_2016) as Variance_2017
,	(SalesPerMonth_2018 - SalesPerMonth_2017) as Variance_2018
,	(SalesPerMonth_2019 - SalesPerMonth_2018) as Variance_2019
,	(SalesPerMonth_2020 - SalesPerMonth_2019) as Variance_2020
,	(SalesPerMonth_2021 - SalesPerMonth_2020) as Variance_2021
,	(SalesPerMonth_2022 - SalesPerMonth_2021) as Variance_2022
from
	[FT].[fn_WP_SalesForecastSummaries_QuoteLog] (@Filter, @FilterValue)
--- </Body>



GO

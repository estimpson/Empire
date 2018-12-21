SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[usp_Web_SalesForecastUpdated_GetEopYears]
as
set nocount on
set ansi_warnings off


--- <Body>
select distinct
	year(sf.empire_eop) as EopYear
from
	eeiuser.acctg_csm_vw_select_sales_forecast sf
where
	year(sf.empire_eop) is not null
	and year(sf.empire_eop) > 2016
order by
	EopYear
--- </Body>

GO

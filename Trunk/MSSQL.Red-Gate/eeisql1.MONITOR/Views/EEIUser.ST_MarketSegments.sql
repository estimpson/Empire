SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [EEIUser].[ST_MarketSegments]
as
select
	isnull(f.empire_market_segment, '') as MarketSegment
from 
	EEIUser.acctg_csm_NAIHS acn 
	join EEIUser.acctg_csm_vw_select_sales_forecast f
		on f.mnemonic = acn.[Mnemonic-Vehicle/Plant]
group by
	f.empire_market_segment
GO

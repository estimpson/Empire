SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_copper_spotaverage]
as
Select	date, 
		exchange,
		commodity,
		contract,
		price,
		(Select	sum(price)/count(1) 
		   from	dbo.commodity_prices as cp2
		where	cp2.date>= dateadd(dd, -30, getdate())and
				exchange = 'COMEX' and
				commodity = 'Copper' and
				contract = 'Spot'			) as lastthirtydaySpotAverage
from	dbo.commodity_prices
where	date>= dateadd(m,-6, getdate()) and
		exchange = 'COMEX' and
		commodity = 'Copper' and
		contract = 'Spot'
GO

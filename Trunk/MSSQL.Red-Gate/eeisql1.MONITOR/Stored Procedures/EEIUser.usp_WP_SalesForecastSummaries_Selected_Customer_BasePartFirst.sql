SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_Selected_Customer_BasePartFirst]
	@Filter varchar(50)
,	@FilterValue varchar(250)
as
set nocount on
set ansi_warnings on


--- <Body>
declare
	@forecastData table
(	empire_application varchar(500)
,	empire_market_subsegment varchar(200)
,	base_part varchar(50)
,	program varchar(255)
,	Cal_16_Sales decimal (38,6)
,	Cal_17_Sales decimal (38,6)
,	Cal_18_Sales decimal (38,6)
,	Cal_19_Sales decimal (38,6)
,	Cal_20_Sales decimal (38,6)
,	Cal_21_Sales decimal (38,6)
,	Cal_22_Sales decimal (38,6)
,	Cal_23_Sales decimal (38,6)
,	Cal_24_Sales decimal (38,6)
,	Cal_25_Sales decimal (38,6)
)

insert
	@forecastData
select 
	sf.empire_application
,	sf.empire_market_subsegment
,	sf.base_part
,	sf.program
,	coalesce(sf.Cal_16_Sales, 0)
,	coalesce(sf.Cal_17_Sales, 0)
,	coalesce(sf.Cal_18_Sales, 0)
,	coalesce(sf.Cal_19_Sales, 0)
,	coalesce(sf.Cal_20_Sales, 0)
,	coalesce(sf.Cal_21_Sales, 0)
,	coalesce(sf.Cal_22_Sales, 0)
,	coalesce(sf.Cal_23_Sales, 0)
,	coalesce(sf.Cal_24_Sales, 0)
,	coalesce(sf.Cal_25_Sales, 0)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast sf
where 
	@Filter = 'Customer' or @Filter = 'Customer Actual'
	and sf.customer = @FilterValue
	

select 
	fd.program
,	fd.base_part
,	fd.empire_market_subsegment
,	fd.empire_application
,	sum(Cal_16_Sales) as Sales_2016
,	sum(Cal_17_Sales) as Sales_2017
,	sum(Cal_18_Sales) as Sales_2018
,	sum(Cal_19_Sales) as Sales_2019
,	sum(Cal_20_Sales) as Sales_2020
,	sum(Cal_21_Sales) as Sales_2021
,	sum(Cal_22_Sales) as Sales_2022
,	sum(Cal_23_Sales) as Sales_2023
,	sum(Cal_24_Sales) as Sales_2024
,	sum(Cal_25_Sales) as Sales_2025
,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
,	(sum(Cal_23_Sales) - sum(Cal_22_Sales)) as Change_2023
,	(sum(Cal_24_Sales) - sum(Cal_23_Sales)) as Change_2024
,	(sum(Cal_25_Sales) - sum(Cal_24_Sales)) as Change_2025
from 
	@forecastData fd
group by 
	fd.base_part
,	fd.empire_market_subsegment
,	fd.empire_application
,	fd.program
order by
	fd.program asc
,	fd.base_part asc
,	fd.empire_market_subsegment asc
,	fd.empire_application asc

return
GO

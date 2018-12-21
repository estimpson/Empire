SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_Selected_Volumes_ProgramSalesperson_BasePartFirst]
	@Filter varchar(50)
,	@FilterValue varchar(250)
as
set nocount on
set ansi_warnings on

--- <Body>
declare @forecastData table
(	
	customer varchar(50)
,	empire_application varchar(500)
,	empire_market_subsegment varchar(200)
,	base_part varchar(50)
,	Cal_16_Volume decimal (38,6)
,	Cal_17_Volume decimal (38,6)
,	Cal_18_Volume decimal (38,6)
,	Cal_19_Volume decimal (38,6)
,	Cal_20_Volume decimal (38,6)
,	Cal_21_Volume decimal (38,6)
,	Cal_22_Volume decimal (38,6)
,	Cal_23_Volume decimal (38,6)
,	Cal_24_Volume decimal (38,6)
,	Cal_25_Volume decimal (38,6)
)


insert
	@forecastData
select 
	sf.customer
,	sf.empire_application
,	sf.empire_market_subsegment
,	sf.base_part
,	coalesce(sf.Cal_16_TotalDemand, 0)
,	coalesce(sf.Cal_17_TotalDemand, 0)
,	coalesce(sf.Cal_18_TotalDemand, 0)
,	coalesce(sf.Cal_19_TotalDemand, 0)
,	coalesce(sf.Cal_20_TotalDemand, 0)
,	coalesce(sf.Cal_21_TotalDemand, 0)
,	coalesce(sf.Cal_22_TotalDemand, 0)
,	coalesce(sf.Cal_23_TotalDemand, 0)
,	coalesce(sf.Cal_24_TotalDemand, 0)
,	coalesce(sf.Cal_25_TotalDemand, 0)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast sf
where 
(	
	@Filter = 'Program' or @Filter = 'Program Forecast'
	and sf.program = @FilterValue
)
or
(	
	@Filter = 'Salesperson' or @Filter = 'Salesperson Actual'
	and sf.salesperson = @FilterValue
)


select 
	fd.base_part
,	fd.customer
,	fd.empire_market_subsegment
,	fd.empire_application
,	sum(Cal_16_Volume) as TotalDemand_2016
,	sum(Cal_17_Volume) as TotalDemand_2017
,	sum(Cal_18_Volume) as TotalDemand_2018
,	sum(Cal_19_Volume) as TotalDemand_2019
,	sum(Cal_20_Volume) as TotalDemand_2020
,	sum(Cal_21_Volume) as TotalDemand_2021
,	sum(Cal_22_Volume) as TotalDemand_2022
,	sum(Cal_23_Volume) as TotalDemand_2023
,	sum(Cal_24_Volume) as TotalDemand_2024
,	sum(Cal_25_Volume) as TotalDemand_2025
,	(sum(Cal_17_Volume) - sum(Cal_16_Volume)) as Change_2017
,	(sum(Cal_18_Volume) - sum(Cal_17_Volume)) as Change_2018
,	(sum(Cal_19_Volume) - sum(Cal_18_Volume)) as Change_2019
,	(sum(Cal_20_Volume) - sum(Cal_19_Volume)) as Change_2020
,	(sum(Cal_21_Volume) - sum(Cal_20_Volume)) as Change_2021
,	(sum(Cal_22_Volume) - sum(Cal_21_Volume)) as Change_2022
,	(sum(Cal_23_Volume) - sum(Cal_22_Volume)) as Change_2023
,	(sum(Cal_24_Volume) - sum(Cal_23_Volume)) as Change_2024
,	(sum(Cal_25_Volume) - sum(Cal_24_Volume)) as Change_2025
from 
	@forecastData fd
group by 
	fd.base_part
,	fd.customer
,	fd.empire_market_subsegment
,	fd.empire_application
order by
	fd.customer asc
,	fd.base_part asc
,	fd.empire_market_subsegment asc
,	fd.empire_application asc

return

GO

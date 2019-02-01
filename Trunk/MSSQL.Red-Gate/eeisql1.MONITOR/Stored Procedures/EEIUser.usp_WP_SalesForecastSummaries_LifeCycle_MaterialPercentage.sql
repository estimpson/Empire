SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_LifeCycle_MaterialPercentage]
	@Filter varchar(50)
,	@ParentCustomerFilter varchar(50) = null
as
set nocount on
set ansi_warnings on



--- <Body>
declare @forecastData table
(	
	BasePart varchar(30)
--,	EmpireApplication varchar(500)
--,	EmpireMarketSubsegment varchar(200)
--,	Program varchar(255)
,	ParentCustomer varchar(50)
,	Customer varchar(50)
,	DisplaySOP datetime
,	DisplayEOP datetime
,	MC_Dec_18 decimal (38,6)
,	SP_Dec_18 decimal (38,6)
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

if (rtrim(coalesce(@ParentCustomerFilter, '')) = '') begin

	insert
		@forecastData
	select 
		sf.base_part
	--,	sf.empire_application
	--,	sf.empire_market_subsegment
	--,	sf.program
	,	''
	,	sf.customer
	,	sf.sop_display
	,	sf.eop_display
	,	coalesce(sf.mc_Dec_18, 0)
	,	coalesce(sf.sp_Dec_18, 0)
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
		( @Filter = 'Pre-production' 
			and coalesce(year(sf.sop_display), 2018) >= 2019 )
		or ( @Filter = 'Launch 2017' 
			and coalesce(year(sf.sop_display), 2016) = 2017 )
		or ( @Filter = 'Launch 2018' 
			and coalesce(year(sf.sop_display), 2017) = 2018 )
		or ( @Filter = 'Production' 
			and coalesce(year(sf.sop_display), 2018) < 2017 
			and coalesce(year(sf.eop_display), 2016) > 2018 )
		or ( @Filter = 'Closeouts 2018'
			and coalesce(year(sf.eop_display), 2017) = 2018 )
		or ( @Filter = 'Closeouts 2019'
			and coalesce(year(sf.eop_display), 2018) = 2019 )
		or ( @Filter = 'Service'
			and coalesce(year(sf.eop_display), 2016) <= 2017 )
		or ( @Filter = 'Summary' )

end
else begin

	insert
		@forecastData
	select 
		sf.base_part
	--,	sf.empire_application
	--,	sf.empire_market_subsegment
	--,	sf.program
	,	sf.parent_customer
	,	sf.customer
	,	sf.sop_display
	,	sf.eop_display
	,	coalesce(sf.mc_Dec_18, 0)
	,	coalesce(sf.sp_Dec_18, 0)
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
		sf.parent_customer = @ParentCustomerFilter
		and
		( 
			( @Filter = 'Pre-production' 
				and coalesce(year(sf.sop_display), 2018) >= 2019 )
			or ( @Filter = 'Launch 2017' 
				and coalesce(year(sf.sop_display), 2016) = 2017 )
			or ( @Filter = 'Launch 2018' 
				and coalesce(year(sf.sop_display), 2017) = 2018 )
			or ( @Filter = 'Production' 
				and coalesce(year(sf.sop_display), 2018) < 2017 
				and coalesce(year(sf.eop_display), 2016) > 2018 )
			or ( @Filter = 'Closeouts 2018'
				and coalesce(year(sf.eop_display), 2017) = 2018 )
			or ( @Filter = 'Closeouts 2019'
				and coalesce(year(sf.eop_display), 2018) = 2019 )
			or ( @Filter = 'Service'
				and coalesce(year(sf.eop_display), 2016) <= 2017 )
			or ( @Filter = 'Summary' ) 
		)

end
;

with cte_MP (BasePart, MaterialPercentage)
as
(
	select
		fd.BasePart as BasePart
	,	convert(varchar, convert(decimal(10,2), (avg(fd.MC_Dec_18) / avg(fd.SP_Dec_18) * 100))) as MaterialPercentage
	from
		@forecastData fd
	where
		fd.MC_Dec_18 > 0
		and fd.SP_Dec_18 > 0
	group by 
		fd.BasePart
)
select 
	fd.Customer
,	fd.BasePart
,	convert(varchar, convert(date, min(fd.DisplaySOP))) as DisplaySOP
,	convert(varchar, convert(date, max(fd.DisplayEOP))) as DisplayEOP
--,	min(fd.DisplaySOP) as DisplaySOP
--,	max(fd.DisplayEOP) as DisplayEOP
--,	fd.EmpireMarketSubsegment
--,	fd.EmpireApplication
,	cte.MaterialPercentage
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
	join cte_MP cte
		on cte.BasePart = fd.BasePart
group by 
	fd.BasePart
,	fd.Customer
,	cte.MaterialPercentage	
order by
	fd.Customer asc
,	fd.BasePart asc
GO

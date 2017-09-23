SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_Selected]
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
,	Cal_16_Sales decimal (38,6)
,	Cal_17_Sales decimal (38,6)
,	Cal_18_Sales decimal (38,6)
,	Cal_19_Sales decimal (38,6)
,	Cal_20_Sales decimal (38,6)
,	Cal_21_Sales decimal (38,6)
,	Cal_22_Sales decimal (38,6)
)

insert
	@forecastData
select 
	sf.empire_application
,	sf.empire_market_subsegment
,	coalesce(sf.Cal_16_Sales, 0)
,	coalesce(sf.Cal_17_Sales, 0)
,	coalesce(sf.Cal_18_Sales, 0)
,	coalesce(sf.Cal_19_Sales, 0)
,	coalesce(sf.Cal_20_Sales, 0)
,	coalesce(sf.Cal_21_Sales, 0)
,	coalesce(sf.Cal_22_Sales, 0)
from 
	eeiuser.acctg_csm_vw_select_sales_forecast sf
where 
	(	@Filter = 'Customer'
		and sf.customer = @FilterValue
	)
	or
	(	@Filter = 'Parent Customer'
		and sf.parent_customer = @FilterValue
	)
	or
	(	@Filter = 'Salesperson'
		and sf.salesperson = @FilterValue
	)
	or
	(	@Filter = 'Segment'
		and sf.empire_market_segment = @FilterValue
	)
	or
	(	@Filter = 'Vehicle'
		and sf.vehicle = @FilterValue
	)
	or
	(	@Filter = 'Program'
		and sf.program = @FilterValue
	)
	or
	(	@Filter = 'Product Line'
		and sf.product_line = @FilterValue
	)

declare
	@uniqueMarketSubsegments table
(	EmpireMarketSubsegment varchar(250)
)

insert
	@uniqueMarketSubsegments
(	EmpireMarketSubsegment
)
select
	empire_market_subsegment
from 
	@forecastData
group by 
	empire_market_subsegment

select 
	ID = empire_market_subsegment
,	ParentID = ''
,	sum(Cal_16_Sales) as Sales_2016
,	sum(Cal_17_Sales) as Sales_2017
,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
,	sum(Cal_18_Sales) as Sales_2018
,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
,	sum(Cal_19_Sales) as Sales_2019
,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
,	sum(Cal_20_Sales) as Sales_2020
,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
,	sum(Cal_21_Sales) as Sales_2021
,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
,	sum(Cal_22_Sales) as Sales_2022
,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
from 
	@forecastData sf
group by
	sf.empire_market_subsegment

union all

select 
	empire_application as ID
,	empire_market_subsegment as ParentID
,	sum(Cal_16_Sales) as Sales_2016
,	sum(Cal_17_Sales) as Sales_2017
,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
,	sum(Cal_18_Sales) as Sales_2018
,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
,	sum(Cal_19_Sales) as Sales_2019
,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
,	sum(Cal_20_Sales) as Sales_2020
,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
,	sum(Cal_21_Sales) as Sales_2021
,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
,	sum(Cal_22_Sales) as Sales_2022
,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
from 
	@forecastData sf
group by 
	empire_market_subsegment
,	empire_application
order by
	Sales_2018 desc

return
/*
declare @uniqueMarketSubsegments table
(
	EmpireMarketSubsegment varchar(250)
)

if (@Filter = 'Customer') begin

	insert into @uniqueMarketSubsegments
	(
		EmpireMarketSubsegment
	)
	select
		empire_market_subsegment
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		customer = @FilterValue
	group by 
		empire_market_subsegment


	select 
		ID = empire_market_subsegment
	,	ParentID = ''
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		sf.customer = @FilterValue
	group by
		sf.empire_market_subsegment
	
	union all

	select 
		empire_application as ID
	,	empire_market_subsegment as ParentID
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		@uniqueMarketSubsegments ums
		join eeiuser.acctg_csm_vw_select_sales_forecast sf
			on sf.empire_market_subsegment = ums.EmpireMarketSubsegment
	where 
		sf.customer = @FilterValue
	group by 
		empire_market_subsegment
	,	empire_application
	order by
		Sales_2018 desc
	
end
else if (@Filter = 'Parent Customer') begin

	insert into @uniqueMarketSubsegments
	(
		EmpireMarketSubsegment
	)
	select
		empire_market_subsegment
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		parent_customer = @FilterValue
	group by 
		empire_market_subsegment


	select 
		ID = empire_market_subsegment
	,	ParentID = ''
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		sf.parent_customer = @FilterValue
	group by
		sf.empire_market_subsegment
	
	union all

	select 
		empire_application as ID
	,	empire_market_subsegment as ParentID
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		@uniqueMarketSubsegments ums
		join eeiuser.acctg_csm_vw_select_sales_forecast sf
			on sf.empire_market_subsegment = ums.EmpireMarketSubsegment
	where 
		sf.parent_customer = @FilterValue
	group by 
		empire_market_subsegment
	,	empire_application
	order by
		Sales_2018 desc

end
else if (@Filter = 'Salesperson') begin

	insert into @uniqueMarketSubsegments
	(
		EmpireMarketSubsegment
	)
	select
		empire_market_subsegment
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		salesperson = @FilterValue
	group by 
		empire_market_subsegment


	select 
		ID = empire_market_subsegment
	,	ParentID = ''
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		sf.salesperson = @FilterValue
	group by
		sf.empire_market_subsegment
	
	union all

	select 
		empire_application as ID
	,	empire_market_subsegment as ParentID
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		@uniqueMarketSubsegments ums
		join eeiuser.acctg_csm_vw_select_sales_forecast sf
			on sf.empire_market_subsegment = ums.EmpireMarketSubsegment
	where 
		sf.salesperson = @FilterValue
	group by 
		empire_market_subsegment
	,	empire_application
	order by
		Sales_2018 desc

end
else if (@Filter = 'Segment') begin

	insert into @uniqueMarketSubsegments
	(
		EmpireMarketSubsegment
	)
	select
		empire_market_subsegment
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		empire_market_segment = @FilterValue
	group by 
		empire_market_subsegment


	select 
		ID = empire_market_subsegment
	,	ParentID = ''
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		sf.empire_market_segment = @FilterValue
	group by
		sf.empire_market_subsegment
	
	union all

	select 
		empire_application as ID
	,	empire_market_subsegment as ParentID
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		@uniqueMarketSubsegments ums
		join eeiuser.acctg_csm_vw_select_sales_forecast sf
			on sf.empire_market_subsegment = ums.EmpireMarketSubsegment
	where 
		sf.empire_market_segment = @FilterValue
	group by 
		empire_market_subsegment
	,	empire_application
	order by
		Sales_2018 desc

end
else if (@Filter = 'Vehicle') begin

	insert into @uniqueMarketSubsegments
	(
		EmpireMarketSubsegment
	)
	select
		empire_market_subsegment
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		vehicle = @FilterValue
	group by 
		empire_market_subsegment


	select 
		ID = empire_market_subsegment
	,	ParentID = ''
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		sf.vehicle = @FilterValue
	group by
		sf.empire_market_subsegment
	
	union all

	select 
		empire_application as ID
	,	empire_market_subsegment as ParentID
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		@uniqueMarketSubsegments ums
		join eeiuser.acctg_csm_vw_select_sales_forecast sf
			on sf.empire_market_subsegment = ums.EmpireMarketSubsegment
	where 
		sf.vehicle = @FilterValue
	group by 
		empire_market_subsegment
	,	empire_application
	order by
		Sales_2018 desc

end
else if (@Filter = 'Program') begin

	insert into @uniqueMarketSubsegments
	(
		EmpireMarketSubsegment
	)
	select
		empire_market_subsegment
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		program = @FilterValue
	group by 
		empire_market_subsegment


	select 
		ID = empire_market_subsegment
	,	ParentID = ''
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		sf.program = @FilterValue
	group by
		sf.empire_market_subsegment
	
	union all

	select 
		empire_application as ID
	,	empire_market_subsegment as ParentID
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		@uniqueMarketSubsegments ums
		join eeiuser.acctg_csm_vw_select_sales_forecast sf
			on sf.empire_market_subsegment = ums.EmpireMarketSubsegment
	where 
		sf.program = @FilterValue
	group by 
		empire_market_subsegment
	,	empire_application
	order by
		Sales_2018 desc

end
else if (@Filter = 'Product Line') begin

	execute
		EEIUser.usp_WP_SalesForecastSummaries_Selected_byProductLine
		@Filter = @Filter
	,	@FilterValue = @FilterValue

*/
/*	insert into @uniqueMarketSubsegments
	(
		EmpireMarketSubsegment
	)
	select
		empire_market_subsegment
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		product_line = @FilterValue
	group by 
		empire_market_subsegment


	select 
		ID = empire_market_subsegment
	,	ParentID = ''
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		eeiuser.acctg_csm_vw_select_sales_forecast sf
	where 
		sf.product_line = @FilterValue
	group by
		sf.empire_market_subsegment
	
	union all

	select 
		empire_application as ID
	,	empire_market_subsegment as ParentID
	,	sum(Cal_16_Sales) as Sales_2016
	,	sum(Cal_17_Sales) as Sales_2017
	,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
	,	sum(Cal_18_Sales) as Sales_2018
	,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
	,	sum(Cal_19_Sales) as Sales_2019
	,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
	,	sum(Cal_20_Sales) as Sales_2020
	,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
	,	sum(Cal_21_Sales) as Sales_2021
	,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
	,	sum(Cal_22_Sales) as Sales_2022
	,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
	from 
		@uniqueMarketSubsegments ums
		join eeiuser.acctg_csm_vw_select_sales_forecast sf
			on sf.empire_market_subsegment = ums.EmpireMarketSubsegment
	where 
		sf.product_line = @FilterValue
	group by 
		empire_market_subsegment
	,	empire_application
	order by
		Sales_2018 desc
*/
/*
end
*/
GO

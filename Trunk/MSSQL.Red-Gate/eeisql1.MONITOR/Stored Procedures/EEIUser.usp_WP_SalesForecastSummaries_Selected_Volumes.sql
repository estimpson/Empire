SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_Selected_Volumes]
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
,	Cal_16_Volume decimal (38,6)
,	Cal_17_Volume decimal (38,6)
,	Cal_18_Volume decimal (38,6)
,	Cal_19_Volume decimal (38,6)
,	Cal_20_Volume decimal (38,6)
,	Cal_21_Volume decimal (38,6)
,	Cal_22_Volume decimal (38,6)
)

insert
	@forecastData
select 
	sf.empire_application
,	sf.empire_market_subsegment
,	coalesce(sf.Total_2016_TotalDemand, 0)
,	coalesce(sf.Total_2017_TotalDemand, 0)
,	coalesce(sf.Total_2018_TotalDemand, 0)
,	coalesce(sf.Total_2019_TotalDemand, 0)
,	coalesce(sf.Cal20_TotalDemand, 0)
,	coalesce(sf.Cal21_TotalDemand, 0)
,	coalesce(sf.Cal22_TotalDemand, 0)
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
,	sum(sf.Cal_16_Volume) as TotalDemand_2016
,	sum(sf.Cal_17_Volume) as TotalDemand_2017
,	(sum(sf.Cal_17_Volume) - sum(sf.Cal_16_Volume)) as Change_2017
,	sum(sf.Cal_18_Volume) as TotalDemand_2018
,	(sum(sf.Cal_18_Volume) - sum(sf.Cal_17_Volume)) as Change_2018
,	sum(sf.Cal_19_Volume) as TotalDemand_2019
,	(sum(sf.Cal_19_Volume) - sum(sf.Cal_18_Volume)) as Change_2019
,	sum(sf.Cal_20_Volume) as TotalDemand_2020
,	(sum(sf.Cal_20_Volume) - sum(sf.Cal_19_Volume)) as Change_2020
,	sum(sf.Cal_21_Volume) as TotalDemand_2021
,	(sum(sf.Cal_21_Volume) - sum(sf.Cal_20_Volume)) as Change_2021
,	sum(sf.Cal_22_Volume) as TotalDemand_2022
,	(sum(sf.Cal_22_Volume) - sum(sf.Cal_21_Volume)) as Change_2022
from 
	@forecastData sf
group by
	sf.empire_market_subsegment

union all

select 
	empire_application as ID
,	empire_market_subsegment as ParentID
,	sum(sf.Cal_16_Volume) as TotalDemand_2016
,	sum(sf.Cal_17_Volume) as TotalDemand_2017
,	(sum(sf.Cal_17_Volume) - sum(sf.Cal_16_Volume)) as Change_2017
,	sum(sf.Cal_18_Volume) as TotalDemand_2018
,	(sum(sf.Cal_18_Volume) - sum(sf.Cal_17_Volume)) as Change_2018
,	sum(sf.Cal_19_Volume) as TotalDemand_2019
,	(sum(sf.Cal_19_Volume) - sum(sf.Cal_18_Volume)) as Change_2019
,	sum(sf.Cal_20_Volume) as TotalDemand_2020
,	(sum(sf.Cal_20_Volume) - sum(sf.Cal_19_Volume)) as Change_2020
,	sum(sf.Cal_21_Volume) as TotalDemand_2021
,	(sum(sf.Cal_21_Volume) - sum(sf.Cal_20_Volume)) as Change_2021
,	sum(sf.Cal_22_Volume) as TotalDemand_2022
,	(sum(sf.Cal_22_Volume) - sum(sf.Cal_21_Volume)) as Change_2022
from 
	@forecastData sf
group by 
	empire_market_subsegment
,	empire_application
order by
	TotalDemand_2018 desc

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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		TotalDemand_2018 desc
	
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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		TotalDemand_2018 desc

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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		TotalDemand_2018 desc

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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		TotalDemand_2018 desc

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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		TotalDemand_2018 desc

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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		TotalDemand_2018 desc

end
else if (@Filter = 'Product Line') begin

	insert into @uniqueMarketSubsegments
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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
	,	sum(Total_2016_TotalDemand) as TotalDemand_2016
	,	sum(Total_2017_TotalDemand) as TotalDemand_2017
	,	sum(Total_2018_TotalDemand) as TotalDemand_2018
	,	sum(Total_2019_TotalDemand) as TotalDemand_2019
	,	sum(Cal20_TotalDemand) as TotalDemand_2020
	,	sum(Cal21_TotalDemand) as TotalDemand_2021
	,	sum(Cal22_TotalDemand) as TotalDemand_2022
	,	(sum(Total_2017_TotalDemand) - sum(Total_2016_TotalDemand)) as Change_2017
	,	(sum(Total_2018_TotalDemand) - sum(Total_2017_TotalDemand)) as Change_2018
	,	(sum(Total_2019_TotalDemand) - sum(Total_2018_TotalDemand)) as Change_2019
	,	(sum(Cal20_TotalDemand) - sum(Total_2019_TotalDemand)) as Change_2020
	,	(sum(Cal21_TotalDemand) - sum(Cal20_TotalDemand)) as Change_2021
	,	(sum(Cal22_TotalDemand) - sum(Cal21_TotalDemand)) as Change_2022
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
		TotalDemand_2018 desc

end
*/
GO

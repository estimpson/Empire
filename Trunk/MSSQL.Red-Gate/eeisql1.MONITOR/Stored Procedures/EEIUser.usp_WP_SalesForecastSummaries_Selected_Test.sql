SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_WP_SalesForecastSummaries_Selected_Test]
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
,	sf.base_part
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



---
declare @recursiveForecastData table
(	
	ID int identity(1,1) not null
,	empire_market_subsegment varchar(200)
,	empire_application varchar(500)
,	base_part varchar(50)
,	Sales_2016 decimal (38,6)
,	Sales_2017 decimal (38,6)
,	Sales_2018 decimal (38,6)
,	Sales_2019 decimal (38,6)
,	Sales_2020 decimal (38,6)
,	Sales_2021 decimal (38,6)
,	Sales_2022 decimal (38,6)
,	Change_2017 decimal (38,6)
,	Change_2018 decimal (38,6)
,	Change_2019 decimal (38,6)
,	Change_2020 decimal (38,6)
,	Change_2021 decimal (38,6)
,	Change_2022 decimal (38,6)
,	ParentID int
)

insert into @recursiveForecastData
(
	empire_market_subsegment
,	empire_application
,	base_part
,	Sales_2016
,	Sales_2017
,	Sales_2018
,	Sales_2019
,	Sales_2020
,	Sales_2021
,	Sales_2022
,	Change_2017 
,	Change_2018
,	Change_2019 
,	Change_2020 
,	Change_2021 
,	Change_2022
,	ParentID
)
select 
	sf.empire_market_subsegment
,	'' as empire_application
,	'' as base_part
,	sum(Cal_16_Sales) as Sales_2016
,	sum(Cal_17_Sales) as Sales_2017
,	sum(Cal_18_Sales) as Sales_2018
,	sum(Cal_19_Sales) as Sales_2019
,	sum(Cal_20_Sales) as Sales_2020
,	sum(Cal_21_Sales) as Sales_2021
,	sum(Cal_22_Sales) as Sales_2022
,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
,	ParentID = 0
from 
	@forecastData sf
group by
	sf.empire_market_subsegment


---
insert into @recursiveForecastData
(
	empire_market_subsegment
,	empire_application
,	base_part
,	Sales_2016
,	Sales_2017
,	Sales_2018
,	Sales_2019
,	Sales_2020
,	Sales_2021
,	Sales_2022
,	Change_2017 
,	Change_2018
,	Change_2019 
,	Change_2020 
,	Change_2021 
,	Change_2022
,	ParentID
)
select 
	sf.empire_market_subsegment
,	sf.empire_application
,	'' as base_part
,	sum(Cal_16_Sales) as Sales_2016
,	sum(Cal_17_Sales) as Sales_2017
,	sum(Cal_18_Sales) as Sales_2018
,	sum(Cal_19_Sales) as Sales_2019
,	sum(Cal_20_Sales) as Sales_2020
,	sum(Cal_21_Sales) as Sales_2021
,	sum(Cal_22_Sales) as Sales_2022
,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
,	ParentID = 0
from 
	@forecastData sf
group by 
	sf.empire_market_subsegment
,	sf.empire_application


update
	rfd
set
	rfd.ParentID = rfd2.ID
from
	@recursiveForecastData rfd
	join @recursiveForecastData rfd2
		on rfd2.empire_market_subsegment = rfd.empire_market_subsegment
where
	rfd.empire_application <> ''


---
insert into @recursiveForecastData
(
	empire_market_subsegment
,	empire_application
,	base_part
,	Sales_2016
,	Sales_2017
,	Sales_2018
,	Sales_2019
,	Sales_2020
,	Sales_2021
,	Sales_2022
,	Change_2017 
,	Change_2018
,	Change_2019 
,	Change_2020 
,	Change_2021 
,	Change_2022
,	ParentID
)
select 
	sf.empire_market_subsegment
,	sf.empire_application
,	sf.base_part
,	sum(Cal_16_Sales) as Sales_2016
,	sum(Cal_17_Sales) as Sales_2017
,	sum(Cal_18_Sales) as Sales_2018
,	sum(Cal_19_Sales) as Sales_2019
,	sum(Cal_20_Sales) as Sales_2020
,	sum(Cal_21_Sales) as Sales_2021
,	sum(Cal_22_Sales) as Sales_2022
,	(sum(Cal_17_Sales) - sum(Cal_16_Sales)) as Change_2017
,	(sum(Cal_18_Sales) - sum(Cal_17_Sales)) as Change_2018
,	(sum(Cal_19_Sales) - sum(Cal_18_Sales)) as Change_2019
,	(sum(Cal_20_Sales) - sum(Cal_19_Sales)) as Change_2020
,	(sum(Cal_21_Sales) - sum(Cal_20_Sales)) as Change_2021
,	(sum(Cal_22_Sales) - sum(Cal_21_Sales)) as Change_2022
,	ParentID = 0
from 
	@forecastData sf
group by 
	sf.empire_market_subsegment
,	sf.empire_application
,	sf.base_part


update
	rfd
set
	rfd.ParentID = rfd2.ID
from
	@recursiveForecastData rfd
	join @recursiveForecastData rfd2
		on rfd2.empire_market_subsegment = rfd.empire_market_subsegment
		and rfd2.empire_application = rfd.empire_application
where
	rfd.base_part <> ''



---
select 
	ID
,	empire_market_subsegment
,	empire_application
,	base_part
,	Sales_2016
,	Sales_2017
,	Sales_2018
,	Sales_2019
,	Sales_2020
,	Sales_2021
,	Sales_2022
,	Change_2017 
,	Change_2018
,	Change_2019 
,	Change_2020 
,	Change_2021 
,	Change_2022
,	ParentID
from 
	@recursiveForecastData rfd
order by
	Sales_2018 desc


return
GO

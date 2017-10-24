SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[usp_WP_SalesForecastSummaries_Selected_Volumes]
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
,	sf.base_part
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


---
declare @recursiveForecastData table
(	
	ID int identity(1,1) not null
,	empire_market_subsegment varchar(200)
,	empire_application varchar(500)
,	TotalDemand_2016 decimal (38,6)
,	TotalDemand_2017 decimal (38,6)
,	TotalDemand_2018 decimal (38,6)
,	TotalDemand_2019 decimal (38,6)
,	TotalDemand_2020 decimal (38,6)
,	TotalDemand_2021 decimal (38,6)
,	TotalDemand_2022 decimal (38,6)
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
,	TotalDemand_2016
,	TotalDemand_2017
,	TotalDemand_2018
,	TotalDemand_2019
,	TotalDemand_2020
,	TotalDemand_2021
,	TotalDemand_2022
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
,	sum(Cal_16_Volume) as TotalDemand_2016
,	sum(Cal_17_Volume) as TotalDemand_2017
,	sum(Cal_18_Volume) as TotalDemand_2018
,	sum(Cal_19_Volume) as TotalDemand_2019
,	sum(Cal_20_Volume) as TotalDemand_2020
,	sum(Cal_21_Volume) as TotalDemand_2021
,	sum(Cal_22_Volume) as TotalDemand_2022
,	(sum(Cal_17_Volume) - sum(Cal_16_Volume)) as Change_2017
,	(sum(Cal_18_Volume) - sum(Cal_17_Volume)) as Change_2018
,	(sum(Cal_19_Volume) - sum(Cal_18_Volume)) as Change_2019
,	(sum(Cal_20_Volume) - sum(Cal_19_Volume)) as Change_2020
,	(sum(Cal_21_Volume) - sum(Cal_20_Volume)) as Change_2021
,	(sum(Cal_22_Volume) - sum(Cal_21_Volume)) as Change_2022
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
,	TotalDemand_2016
,	TotalDemand_2017
,	TotalDemand_2018
,	TotalDemand_2019
,	TotalDemand_2020
,	TotalDemand_2021
,	TotalDemand_2022
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
,	sf.empire_application + ' : ' + FX.ToList(distinct sf.base_part)
,	sum(Cal_16_Volume) as TotalDemand_2016
,	sum(Cal_17_Volume) as TotalDemand_2017
,	sum(Cal_18_Volume) as TotalDemand_2018
,	sum(Cal_19_Volume) as TotalDemand_2019
,	sum(Cal_20_Volume) as TotalDemand_2020
,	sum(Cal_21_Volume) as TotalDemand_2021
,	sum(Cal_22_Volume) as TotalDemand_2022
,	(sum(Cal_17_Volume) - sum(Cal_16_Volume)) as Change_2017
,	(sum(Cal_18_Volume) - sum(Cal_17_Volume)) as Change_2018
,	(sum(Cal_19_Volume) - sum(Cal_18_Volume)) as Change_2019
,	(sum(Cal_20_Volume) - sum(Cal_19_Volume)) as Change_2020
,	(sum(Cal_21_Volume) - sum(Cal_20_Volume)) as Change_2021
,	(sum(Cal_22_Volume) - sum(Cal_21_Volume)) as Change_2022
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
select 
	ID
,	empire_market_subsegment
,	empire_application
,	TotalDemand_2016
,	TotalDemand_2017
,	TotalDemand_2018
,	TotalDemand_2019
,	TotalDemand_2020
,	TotalDemand_2021
,	TotalDemand_2022
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
	TotalDemand_2018 desc


return
GO

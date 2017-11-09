SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[usp_WP_UpdateCsmDemand_EmpireFactor_GetHistoryByBasePart] 
	@BasePart varchar(50)	
,	@StartDate datetime
,	@EndDate datetime
as
set nocount on
set ansi_warnings off

--- <Body>
declare @MinHistory table
(
	Total2015 decimal(20,6)
,	Total2016 decimal(20,6)
,	Total2017 decimal(20,6)
,	Total2018 decimal(20,6)
,	Total2019 decimal(20,6)
,	Total2020 decimal(20,6)
,	Total2021 decimal(20,6)
,	Total2022 decimal(20,6)
)

insert into 
	@MinHistory
select
	Total2015
,	Total2016
,	Total2017
,	Total2018
,	Total2019
,	Total2020
,	Total2021
,	Total2022
from
	EEIUser.WP_SalesForecast_EmpireFactor_History efh
where
	efh.BasePart = @BasePart
	and efh.DateStamp =
		(	
			select
				min(DateStamp)
			from
				EEIUser.WP_SalesForecast_EmpireFactor_History efh2
			where
				efh2.BasePart = @BasePart
				and efh2.DateStamp between @StartDate and @EndDate )


select
	@BasePart as BasePart
,	maxHistory.Total2015 - minHistory.Total2015 as Change2015
,	maxHistory.Total2016 - minHistory.Total2016 as Change2016
,	maxHistory.Total2017 - minHistory.Total2017 as Change2017
,	maxHistory.Total2018 - minHistory.Total2018 as Change2018
,	maxHistory.Total2019 - minHistory.Total2019 as Change2019
,	maxHistory.Total2020 - minHistory.Total2020 as Change2020
,	maxHistory.Total2021 - minHistory.Total2021 as Change2021
,	maxHistory.Total2022 - minHistory.Total2022 as Change2022
from
	EEIUser.WP_SalesForecast_EmpireFactor_History maxHistory
	join @MinHistory minHistory
		on minHistory.BasePart = maxHistory.BasePart
where
	maxHistory.BasePart = @BasePart
	and maxHistory.DateStamp =
		(	
			select
				min(DateStamp)
			from
				EEIUser.WP_SalesForecast_EmpireFactor_History efh
			where
				efh.BasePart = @BasePart
				and efh.DateStamp between @StartDate and @EndDate )
--- </Body>

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[usp_WP_UpdateCsmDemand_EmpireFactor_GetHistory] 
	@StartDate datetime
,	@EndDate datetime
as
set nocount on
set ansi_warnings off

--- <Body>
select
	BasePart
,	Vehicle
,	EmpireMarketSegment
,	EmpireApplication
,	DateStamp
,	Jan2015
,	Feb2015
,	Mar2015
,	Apr2015
,	May2015
,	Jun2015
,	Jul2015
,	Aug2015
,	Sep2015
,	Oct2015
,	Nov2015
,	Dec2015
,	Total2015
,	Jan2016
,	Feb2016
,	Mar2016
,	Apr2016
,	May2016
,	Jun2016
,	Jul2016
,	Aug2016
,	Sep2016
,	Oct2016
,	Nov2016
,	Dec2016
,	Total2016
,	Jan2017
,	Feb2017
,	Mar2017
,	Apr2017
,	May2017
,	Jun2017
,	Jul2017
,	Aug2017
,	Sep2017
,	Oct2017
,	Nov2017
,	Dec2017
,	Total2017
,	Jan2018
,	Feb2018
,	Mar2018
,	Apr2018
,	May2018
,	Jun2018
,	Jul2018
,	Aug2018
,	Sep2018
,	Oct2018
,	Nov2018
,	Dec2018
,	Total2018
,	Jan2019
,	Feb2019
,	Mar2019
,	Apr2019
,	May2019
,	Jun2019
,	Jul2019
,	Aug2019
,	Sep2019
,	Oct2019
,	Nov2019
,	Dec2019
,	Total2019
,	Total2020
,	Total2021
,	Total2022
from
	EEIUser.WP_SalesForecast_EmpireFactor_History efh
where
	efh.DateStamp between @StartDate and @EndDate
order by
	BasePart
,	Vehicle
,	EmpireMarketSegment
,	EmpireApplication
,	DateStamp asc
--- </Body>

GO

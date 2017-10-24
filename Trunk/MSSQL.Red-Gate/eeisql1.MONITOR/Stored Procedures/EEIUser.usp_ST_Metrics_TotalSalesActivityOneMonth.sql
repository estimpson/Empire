SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Metrics_TotalSalesActivityOneMonth]
as
set nocount on
set ansi_warnings on;

--- <Body>
select 
	count(case when d.Status = 0 then 1 end) as Opened
,	count(case when d.Status = 1 then 1 end) as Quoted
,	count(case when d.Status = 2 then 1 end) as Awarded
,	count(case when d.Status = 3 then 1 end) as Closed
from 
	eeiuser.ST_SalesLeadLog_Detail d
where
	d.ActivityDate between dateadd(day, -30, getdate()) and dateadd(day, 1, getdate())
--- </Body>
GO

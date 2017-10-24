SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Metrics_ProgramsLaunchingByCustomer]
as
set nocount on
set ansi_warnings off

--- <Body>
-- Number of programs launching from 2017-2019 by customer
select
	ls.Customer
,	max(HeadLamps.HeadLampProgramsLaunching) as HeadLampCount
,	max(TailLamps.TailLampProgramsLaunching) as TailLampCount
from
	EEIUser.vw_ST_LightingStudy_2016 ls
	join (
			select
				ls2.Customer
			,	count(1) as HeadLampProgramsLaunching
			from
				EEIUser.vw_ST_LightingStudy_2016 ls2
			where
				ls2.Application = 'Headlamp'
			group by
				ls2.Customer ) as HeadLamps
		on HeadLamps.Customer = ls.Customer
	join (
			select
				ls3.Customer
			,	count(1) as TailLampProgramsLaunching
			from
				EEIUser.vw_ST_LightingStudy_2016 ls3
			where
				ls3.Application = 'Tail Lamp'
			group by
				ls3.Customer ) as TailLamps	
		on TailLamps.Customer = ls.Customer
group by
	ls.Customer	
order by
	ls.Customer
--- </Body>
GO

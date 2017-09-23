SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Metrics_PeakVolumeOfProgramsLaunching]
as
set nocount on
set ansi_warnings off

--- <Body>
-- Peak volume of programs launching from 2017-2019 by customer
select
	ls.Customer
,	max(HalogenHeadLamps.HalogenHeadLampPeakVolume) as HalogenHeadLampPeakVolume
,	max(LedHeadLamps.LedHeadLampPeakVolume) as LedHeadLampPeakVolume
,	max(ConventionalTailLamps.ConventionalTailLampPeakVolume) as ConventionalTailLampPeakVolume
,	max(LedTailLamps.LedTailLampPeakVolume) as LedTailLampPeakVolume
from
	EEIUser.vw_ST_LightingStudy_2016 ls
	join (
			select
				ls1.Customer
			,	sum(ls1.PeakVolume) as HalogenHeadLampPeakVolume
			from
				EEIUser.vw_ST_LightingStudy_2016 ls1
			where
				ls1.description = 'Halogen Headlamp'
			group by
				ls1.Customer ) as HalogenHeadLamps
		on HalogenHeadLamps.Customer = ls.Customer
	join (
			select
				ls2.Customer
			,	sum(ls2.PeakVolume) as LedHeadLampPeakVolume
			from
				EEIUser.vw_ST_LightingStudy_2016 ls2
			where
				ls2.description = 'LED Headlamp'
			group by
				ls2.Customer ) as LedHeadLamps
		on LedHeadLamps.Customer = ls.Customer	
	join (
			select
				ls3.Customer
			,	sum(ls3.PeakVolume) as ConventionalTailLampPeakVolume
			from
				EEIUser.vw_ST_LightingStudy_2016 ls3
			where
				ls3.description = 'Conventional Tail Lamp'
			group by
				ls3.Customer ) as ConventionalTailLamps
		on ConventionalTailLamps.Customer = ls.Customer	
	join (
			select
				ls4.Customer
			,	sum(ls4.PeakVolume) as LedTailLampPeakVolume
			from
				EEIUser.vw_ST_LightingStudy_2016 ls4
			where
				ls4.description = 'LED Tail Lamp'
			group by
				ls4.Customer ) as LedTailLamps
		on LedTailLamps.Customer = ls.Customer	
group by
	ls.Customer
order by
	ls.Customer
--- </Body>
GO

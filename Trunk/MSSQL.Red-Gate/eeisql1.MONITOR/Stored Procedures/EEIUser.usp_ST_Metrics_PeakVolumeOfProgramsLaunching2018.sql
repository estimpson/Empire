SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Metrics_PeakVolumeOfProgramsLaunching2018]
	@Customer varchar(50)
,	@Region varchar(50)
as
set nocount on
set ansi_warnings off

--- <Body>
-- Peak volume of programs launching 2018 by customer
declare @temp table
(
	Program varchar(50)
,	HalogenHeadlampPeakVolume2018 int null
,	LedHeadlampPeakVolume2018 int null
,	XenonHeadlampPeakVolume2018 int null
,	ConventionalTaillampPeakVolume2018 int null
,	LedTaillampPeakVolume2018 int null
)

-- Halogen Headlamp peak volume 2018
insert @temp
(
	[@temp].Program
,	[@temp].HalogenHeadlampPeakVolume2018
)
select
	max(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)
,	max(ls.PeakVolume)
from
	EEIUser.vw_ST_LightingStudy_2016 ls
where
	ls.Customer = @Customer
	and ls.Region = @Region
	and ls.Description = 'Halogen Headlamp'
	and ls.Volume2018 > 0
	and year(ls.SOP) = 2018
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)



-- LED Headlamp peak volume 2018 where unique constraint is not compromised
insert @temp
(
	[@temp].Program
,	[@temp].LedHeadlampPeakVolume2018
) 
select
	max(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)
,	max(ls.PeakVolume)
from
	EEIUser.vw_ST_LightingStudy_2016 ls
where
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) not in (	
			select
				t.Program
			from
				@temp t )
	and ls.Customer = @Customer
	and ls.Region = @Region
	and ls.Description = 'LED Headlamp'
	and ls.Volume2018 > 0
	and year(ls.SOP) = 2018
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) 
	

-- Update LED Headlamp peak volume 2018 where record already exists
declare @tempLedHeadlamp table
(
	Program varchar(50)
,	LedHeadlampVolume2018 int
)

insert into @tempLedHeadlamp
(	
	Program
,	LedHeadlampVolume2018
)
select
	max(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)
,	max(ls.PeakVolume)
from
	EEIUser.vw_ST_LightingStudy_2016 ls
where
	ls.Customer = @Customer
	and ls.Region = @Region
	and ls.Description = 'LED Headlamp'
	and ls.Volume2018 > 0
	and year(ls.SOP) = 2018
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)

update
	t
set
	t.LedHeadlampPeakVolume2018 = tled.LedHeadlampVolume2018
from
	@temp t
	join @tempLedHeadlamp tled
		on tled.Program = t.Program



-- Xenon Headlamp peak volume 2018 where unique constraint is not compromised
insert @temp
(
	[@temp].Program
,	[@temp].XenonHeadlampPeakVolume2018
) 
select
	max(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)
,	max(ls.PeakVolume)
from
	EEIUser.vw_ST_LightingStudy_2016 ls
where
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) not in (	
			select
				t.Program
			from
				@temp t )
	and ls.Customer = @Customer
	and ls.Region = @Region
	and ls.Description = 'Xenon Headlamp'
	and ls.Volume2018 > 0
	and year(ls.SOP) = 2018
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) 
	

-- Update Xenon Headlamp peak volume 2018 where record already exists
declare @tempXenonHeadlamp table
(
	Program varchar(50)
,	XenonHeadlampVolume2018 int
)

insert into @tempXenonHeadlamp
(	
	Program
,	XenonHeadlampVolume2018
)
select
	max(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)
,	max(ls.PeakVolume)
from
	EEIUser.vw_ST_LightingStudy_2016 ls
where
	ls.Customer = @Customer
	and ls.Region = @Region
	and ls.Description = 'Xenon Headlamp'
	and ls.Volume2018 > 0
	and year(ls.SOP) = 2018
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)

update
	t
set
	t.XenonHeadlampPeakVolume2018 = tx.XenonHeadlampVolume2018
from
	@temp t
	join @tempXenonHeadlamp tx
		on tx.Program = t.Program
		
		

-- LED Taillamp peak volume 2018 where unique constraint is not compromised
insert @temp
(
	[@temp].Program
,	[@temp].LedTaillampPeakVolume2018
) 
select
	max(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)
,	max(ls.PeakVolume)
from
	EEIUser.vw_ST_LightingStudy_2016 ls
where
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) not in (	
			select
				t.Program
			from
				@temp t )
	and ls.Customer = @Customer
	and ls.Region = @Region
	and ls.Description = 'LED Tail Lamp'
	and ls.Volume2018 > 0
	and year(ls.SOP) = 2018
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) 


-- Update LED Taillamp peak volume 2018 where record already exists
declare @tempLedTaillamp table
(
	Program varchar(50)
,	LedTaillampVolume2018 int
)

insert into @tempLedTaillamp
(	
	Program
,	LedTaillampVolume2018
)
select
	max(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)
,	max(ls.PeakVolume)
from
	EEIUser.vw_ST_LightingStudy_2016 ls
where
	ls.Customer = @Customer
	and ls.Region = @Region
	and ls.Description = 'LED Tail Lamp'
	and ls.Volume2018 > 0
	and year(ls.SOP) = 2018
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)

update
	t
set
	t.LedTaillampPeakVolume2018 = tled.LedTaillampVolume2018
from
	@temp t
	join @tempLedTailLamp tled
		on tled.Program = t.Program



-- Conventional Taillamp peak volume 2018 where unique constraint is not compromised
insert @temp
(
	[@temp].Program
,	[@temp].ConventionalTaillampPeakVolume2018
) 
select
	max(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)
,	max(ls.PeakVolume)
from
	EEIUser.vw_ST_LightingStudy_2016 ls
where
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) not in (	
			select
				t.Program
			from
				@temp t )
	and ls.Customer = @Customer
	and ls.Region = @Region
	and ls.Description = 'Conventional Tail Lamp'
	and ls.Volume2018 > 0
	and year(ls.SOP) = 2018
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) 


-- Update Conventional Taillamp peak volume 2018 where record already exists
declare @tempConventionalTaillamp table
(
	Program varchar(50)
,	ConventionalTaillampVolume2018 int
)

insert into @tempConventionalTailLamp
(	
	Program
,	ConventionalTaillampVolume2018
)
select
	max(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)
,	max(ls.PeakVolume)
from
	EEIUser.vw_ST_LightingStudy_2016 ls
where
	ls.Customer = @Customer
	and ls.Region = @Region
	and ls.Description = 'Conventional Tail Lamp'
	and ls.Volume2018 > 0
	and year(ls.SOP) = 2018
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)

update
	t
set
	t.ConventionalTaillampPeakVolume2018 = tcon.ConventionalTaillampVolume2018
from
	@temp t
	join @tempConventionalTailLamp tcon
		on tcon.Program = t.Program


		
-- Return data
select 
	Program
,	HalogenHeadlampPeakVolume2018
,	LedHeadlampPeakVolume2018
,	XenonHeadlampPeakVolume2018
,	ConventionalTaillampPeakVolume2018
,	LedTaillampPeakVolume2018
from 
	@temp	
--- </Body>





GO

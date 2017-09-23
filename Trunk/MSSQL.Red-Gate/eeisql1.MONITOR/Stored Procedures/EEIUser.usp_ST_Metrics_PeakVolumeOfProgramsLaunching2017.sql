SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Metrics_PeakVolumeOfProgramsLaunching2017]
	@Customer varchar(50)
,	@Region varchar(50)
as
set nocount on
set ansi_warnings off

--- <Body>
-- Peak volume of programs launching 2017 by customer
declare @temp table
(
	Program varchar(50)
,	HalogenHeadlampPeakVolume2017 int null
,	HalogenHeadlampStatus varchar(50) null
,	LedHeadlampPeakVolume2017 int null
,	XenonHeadlampPeakVolume2017 int null
,	ConventionalTaillampPeakVolume2017 int null
,	LedTaillampPeakVolume2017 int null
)

-- Halogen Headlamp peak volume 2017
insert @temp
(
	[@temp].Program
,	[@temp].HalogenHeadlampPeakVolume2017
)
select
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)
,	max(ls.PeakVolume)
from
	EEIUser.vw_ST_LightingStudy_2016 ls
where
	ls.Customer = @Customer
	and ls.Region = @Region
	and ls.Description = 'Halogen Headlamp'
	and ls.Volume2017 > 0
	and year(ls.SOP) = 2017
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)



-- LED Headlamp peak volume 2017 where unique constraint is not compromised
insert @temp
(
	[@temp].Program
,	[@temp].LedHeadlampPeakVolume2017
) 
select
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)
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
	and ls.Volume2017 > 0
	and year(ls.SOP) = 2017
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) 
	

-- Update LED Headlamp peak volume 2017 where record already exists
declare @tempLedHeadlamp table
(
	Program varchar(50)
,	LedHeadlampVolume2017 int
)

insert into @tempLedHeadlamp
(	
	Program
,	LedHeadlampVolume2017
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
	and ls.Volume2017 > 0
	and year(ls.SOP) = 2017
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)

update
	t
set
	t.LedHeadlampPeakVolume2017 = tled.LedHeadlampVolume2017
from
	@temp t
	join @tempLedHeadlamp tled
		on tled.Program = t.Program



-- Xenon Headlamp peak volume 2017 where unique constraint is not compromised
insert @temp
(
	[@temp].Program
,	[@temp].XenonHeadlampPeakVolume2017
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
	and ls.Volume2017 > 0
	and year(ls.SOP) = 2017
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) 
	

-- Update Xenon Headlamp peak volume 2017 where record already exists
declare @tempXenonHeadlamp table
(
	Program varchar(50)
,	XenonHeadlampVolume2017 int
)

insert into @tempXenonHeadlamp
(	
	Program
,	XenonHeadlampVolume2017
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
	and ls.Volume2017 > 0
	and year(ls.SOP) = 2017
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)

update
	t
set
	t.XenonHeadlampPeakVolume2017 = tx.XenonHeadlampVolume2017
from
	@temp t
	join @tempXenonHeadlamp tx
		on tx.Program = t.Program
		
		

-- LED Taillamp peak volume 2017 where unique constraint is not compromised
insert @temp
(
	[@temp].Program
,	[@temp].LedTaillampPeakVolume2017
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
	and ls.Volume2017 > 0
	and year(ls.SOP) = 2017
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) 


-- Update LED Taillamp peak volume 2017 where record already exists
declare @tempLedTaillamp table
(
	Program varchar(50)
,	LedTaillampVolume2017 int
)

insert into @tempLedTaillamp
(	
	Program
,	LedTaillampVolume2017
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
	and ls.Volume2017 > 0
	and year(ls.SOP) = 2017
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)

update
	t
set
	t.LedTaillampPeakVolume2017 = tled.LedTaillampVolume2017
from
	@temp t
	join @tempLedTailLamp tled
		on tled.Program = t.Program



-- Conventional Taillamp peak volume 2017 where unique constraint is not compromised
insert @temp
(
	[@temp].Program
,	[@temp].ConventionalTaillampPeakVolume2017
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
	and ls.Volume2017 > 0
	and year(ls.SOP) = 2017
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) 


-- Update Conventional Taillamp peak volume 2017 where record already exists
declare @tempConventionalTaillamp table
(
	Program varchar(50)
,	ConventionalTaillampVolume2017 int
)

insert into @tempConventionalTailLamp
(	
	Program
,	ConventionalTaillampVolume2017
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
	and ls.Volume2017 > 0
	and year(ls.SOP) = 2017
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)

update
	t
set
	t.ConventionalTaillampPeakVolume2017 = tcon.ConventionalTaillampVolume2017
from
	@temp t
	join @tempConventionalTailLamp tcon
		on tcon.Program = t.Program


		
-- Return data
select 
	Program
,	HalogenHeadlampPeakVolume2017
,	LedHeadlampPeakVolume2017
,	XenonHeadlampPeakVolume2017
,	ConventionalTaillampPeakVolume2017
,	LedTaillampPeakVolume2017
from 
	@temp	
--- </Body>





GO

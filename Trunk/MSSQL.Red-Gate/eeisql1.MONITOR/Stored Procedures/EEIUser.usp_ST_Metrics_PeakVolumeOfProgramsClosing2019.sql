SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Metrics_PeakVolumeOfProgramsClosing2019]
	@Customer varchar(50)
,	@Region varchar(50)
as
set nocount on
set ansi_warnings off

--- <Body>
-- Peak volume of programs launching 2019 by customer
declare @temp table
(
	Program varchar(50)
,	HalogenHeadlampPeakVolume2019 int null
,	LedHeadlampPeakVolume2019 int null
,	XenonHeadlampPeakVolume2019 int null
,	ConventionalTaillampPeakVolume2019 int null
,	LedTaillampPeakVolume2019 int null
)

-- Halogen Headlamp peak volume 2019
insert @temp
(
	[@temp].Program
,	[@temp].HalogenHeadlampPeakVolume2019
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
	and ls.Volume2019 > 0
	and year(ls.EOP) = 2019
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)



-- LED Headlamp peak volume 2019 where unique constraint is not compromised
insert @temp
(
	[@temp].Program
,	[@temp].LedHeadlampPeakVolume2019
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
	and ls.Volume2019 > 0
	and year(ls.EOP) = 2019
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) 
	

-- Update LED Headlamp peak volume 2019 where record already exists
declare @tempLedHeadlamp table
(
	Program varchar(50)
,	LedHeadlampVolume2019 int
)

insert into @tempLedHeadlamp
(	
	Program
,	LedHeadlampVolume2019
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
	and ls.Volume2019 > 0
	and year(ls.EOP) = 2019
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)

update
	t
set
	t.LedHeadlampPeakVolume2019 = tled.LedHeadlampVolume2019
from
	@temp t
	join @tempLedHeadlamp tled
		on tled.Program = t.Program



-- Xenon Headlamp peak volume 2019 where unique constraint is not compromised
insert @temp
(
	[@temp].Program
,	[@temp].XenonHeadlampPeakVolume2019
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
	and ls.Volume2019 > 0
	and year(ls.EOP) = 2019
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) 
	

-- Update Xenon Headlamp peak volume 2019 where record already exists
declare @tempXenonHeadlamp table
(
	Program varchar(50)
,	XenonHeadlampVolume2019 int
)

insert into @tempXenonHeadlamp
(	
	Program
,	XenonHeadlampVolume2019
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
	and ls.Volume2019 > 0
	and year(ls.EOP) = 2019
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)

update
	t
set
	t.XenonHeadlampPeakVolume2019 = tx.XenonHeadlampVolume2019
from
	@temp t
	join @tempXenonHeadlamp tx
		on tx.Program = t.Program
		
		

-- LED Taillamp peak volume 2019 where unique constraint is not compromised
insert @temp
(
	[@temp].Program
,	[@temp].LedTaillampPeakVolume2019
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
	and ls.Volume2019 > 0
	and year(ls.EOP) = 2019
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) 


-- Update LED Taillamp peak volume 2019 where record already exists
declare @tempLedTaillamp table
(
	Program varchar(50)
,	LedTaillampVolume2019 int
)

insert into @tempLedTaillamp
(	
	Program
,	LedTaillampVolume2019
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
	and ls.Volume2019 > 0
	and year(ls.EOP) = 2019
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)

update
	t
set
	t.LedTaillampPeakVolume2019 = tled.LedTaillampVolume2019
from
	@temp t
	join @tempLedTailLamp tled
		on tled.Program = t.Program



-- Conventional Taillamp peak volume 2019 where unique constraint is not compromised
insert @temp
(
	[@temp].Program
,	[@temp].ConventionalTaillampPeakVolume2019
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
	and ls.Volume2019 > 0
	and year(ls.EOP) = 2019
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate) 


-- Update Conventional Taillamp peak volume 2019 where record already exists
declare @tempConventionalTaillamp table
(
	Program varchar(50)
,	ConventionalTaillampVolume2019 int
)

insert into @tempConventionalTailLamp
(	
	Program
,	ConventionalTaillampVolume2019
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
	and ls.Volume2019 > 0
	and year(ls.EOP) = 2019
group by
	(ls.Program + ' - ' + ls.OEM + ' - ' + ls.NamePlate)

update
	t
set
	t.ConventionalTaillampPeakVolume2019 = tcon.ConventionalTaillampVolume2019
from
	@temp t
	join @tempConventionalTailLamp tcon
		on tcon.Program = t.Program


		
-- Return data
select 
	Program
,	HalogenHeadlampPeakVolume2019
,	LedHeadlampPeakVolume2019
,	XenonHeadlampPeakVolume2019
,	ConventionalTaillampPeakVolume2019
,	LedTaillampPeakVolume2019
from 
	@temp	
--- </Body>





GO

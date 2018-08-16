SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[EmpireFacilities]
as
select
	Code = d.destination
,	Name = d.name
from
	MONITOR.dbo.destination d
where
	d.plant = d.destination
	and d.destination in
		(	'EEA', 'EEI', 'EEP' )
GO

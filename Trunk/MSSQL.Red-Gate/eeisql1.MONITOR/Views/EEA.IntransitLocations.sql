SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[IntransitLocations]
as
select
	InTranLocation = o.location
,	ArrivalDate = max
	(	case
			when o.location like 'TRANA[1-9]-' + convert(varchar, ic.IntransitWeekNumberDueFridayOfNextWeek) + '[A-Z]'
				then ic.FridayOfNextWeek
			else
				ic.FridayOfCurrentWeek
		end
	)
from
	dbo.object o
	cross join EEA.IntransitCalendar ic
where
	o.location like 'TRANA[1-9]-%'
group by
	o.location
GO

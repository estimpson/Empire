
/*
Create View.MONITOR.EEA.IntransitLocations.sql
*/

use MONITOR
go

--drop table EEA.IntransitLocations
if	objectproperty(object_id('EEA.IntransitLocations'), 'IsView') = 1 begin
	drop view EEA.IntransitLocations
end
go

create view EEA.IntransitLocations
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
go

select
	*
from
	EEA.IntransitLocations il

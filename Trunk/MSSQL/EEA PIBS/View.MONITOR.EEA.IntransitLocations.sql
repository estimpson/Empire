
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
select distinct
	InTranLocation = o.location
,	ArrivalDate =
	case
		when o.location like 'TRANA[1-9]-' + InTranCalendar.IntransitWeekNumberDueFridayOfNextWeek + '[A-Z]'
			then InTranCalendar.FridayOfNextWeek
		else
			InTranCalendar.FridayOfCurrentWeek
	end
from
	dbo.object o
	cross apply
		(	select
				CurrentWeekNo = datepart(week, getdate())
			,	IntransitWeekNumberDueFridayOfCurrentWeek = datepart(week, getdate()) - 1
			,	IntransitWeekNumberDueFridayOfNextWeek = datepart(week, getdate())
			,	FirstDayOfCurrentWeek =
				dateadd(day, datediff(day, '2001-01-01', getdate()), '2001-01-01')
				- datepart(weekday, getdate()) + 1
			,	FridayOfCurrentWeek = 
				dateadd(day, datediff(day, '2001-01-01', getdate()), '2001-01-01')
				- datepart(weekday, getdate()) + 6
			,	FridayOfNextWeek =
				dateadd(day, datediff(day, '2001-01-01', getdate()), '2001-01-01')
				- datepart(weekday, getdate()) + 13
		) InTranCalendar
where
	o.location like 'TRANA[1-9]-%'
go


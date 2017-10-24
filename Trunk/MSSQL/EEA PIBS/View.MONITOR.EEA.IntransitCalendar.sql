
/*
Create View.MONITOR.EEA.IntransitCalendar.sql
*/

use MONITOR
go

--drop table EEA.IntransitCalendar
if	objectproperty(object_id('EEA.IntransitCalendar'), 'IsView') = 1 begin
	drop view EEA.IntransitCalendar
end
go

create view EEA.IntransitCalendar
as
select
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
go

select
	*
from
	EEA.IntransitCalendar ic

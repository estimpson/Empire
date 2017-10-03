SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[IntransitCalendar]
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
GO

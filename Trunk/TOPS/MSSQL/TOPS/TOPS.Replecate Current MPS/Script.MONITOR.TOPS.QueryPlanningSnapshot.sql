
declare
	@pcXML xml
,	@psXML xml
,	@hsXML xml

select top(1)
	@pcXML = pc.CalendarXML
,	@psXML = ps.PlanningXML
,	@hsXML = hs.HolidayScheduleXML
	--*
from
	TOPS.PlanningSnapshotHeaders psh
	left join TOPS.PlanningCalendars pc
		on pc.RowGUID = psh.PlanningCalendarGUID
	left join TOPS.PlanningSnapshots ps
		on ps.RowGUID = psh.PlanningSnapshotGUID
	left join TOPS.HolidaySchedules hs
		on hs.RowGUID = psh.HolidayScheduleGUID
where
	psh.FinishedPart = 'ACH0020-HE02'
order by
	psh.RowID

select
	@psXML.query('.')
,	@pcXML.query('.')
,	@hsXML.query('.')

declare
	@FinishedPart varchar(25) = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@FinishedPart)[1]', 'varchar(25)')
,	@CountIfMinProduction int = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@CountIfMinProduction)[1]', 'int')
,	@StandardPack numeric(20,6) = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@StandardPack)[1]', 'numeric(20,6)')
,	@CountIfDefaultPO int = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@CountIfDefaultPO)[1]', 'int')
,	@DefaultPO int = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@DefaultPO)[1]', 'int')
,	@SalesPrice numeric(20,6) = @psXML.value('(/PlanningSnapshot/PlanningHeader/PH/@SalesPrice)[1]', 'numeric(20,6)')

declare
	@PlanningTable table
(	CalendarDT datetime not null
,	DailyWeekly char(1) not null
,	WeekNo int not null
,	RowID int not null IDENTITY(1, 1) primary key
)
insert
	@PlanningTable
(	CalendarDT
,	DailyWeekly
,	WeekNo
)
select
	CalendarDT = ce.CalendarEntry.value('(@CalendarDT)[1]', 'datetime')
,	DailyWeekly = ce.CalendarEntry.value('(@DailyWeekly)[1]', 'char(1)')
,	WeekNo = ce.CalendarEntry.value('(@WeekNo)[1]', 'int')
from
	@pcXML.nodes('/PlanningCalendar/Calendar/Entry') as ce(CalendarEntry)

--declare
--	@CustomerRequirements table
--(	DueDT datetime not null
--,	OrderQty numeric(20,6) not null
--,	

select
	@FinishedPart
,	@CountIfMinProduction
,	@StandardPack
,	@CountIfDefaultPO
,	@DefaultPO
,	@SalesPrice
,	pt.CalendarDT
,	DayNumber = datepart(weekday, pt.CalendarDT)
,	pt.DailyWeekly
,	pt.WeekNo
,	CustomerRequirement = 0
,	pt.RowID
from
	@PlanningTable pt
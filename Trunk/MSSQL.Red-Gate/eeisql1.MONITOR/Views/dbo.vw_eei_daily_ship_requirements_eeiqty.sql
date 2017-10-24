SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_daily_ship_requirements_eeiqty]
as
Select	DestinationGP,
		WeeklyOrders.Order_no,
		WeeklyOrders.part_number,
		(CASE WHEN DaysPerWeekShip = 0 THEN OrderDetail.ODDueDT 
		WHEN dateadd(dd, SunDOW, FirstDayofWeek) = EntryDT THEN EntryDT
		WHEN dateadd(dd, MonDOW, FirstDayofWeek) = EntryDT THEN EntryDT
		WHEN dateadd(dd, TueDOW, FirstDayofWeek) = EntryDT THEN EntryDT
		WHEN dateadd(dd, WedDOW, FirstDayofWeek) = EntryDT THEN EntryDT
		WHEN dateadd(dd, ThuDOW, FirstDayofWeek) = EntryDT THEN EntryDT
		WHEN dateadd(dd, FriDOW, FirstDayofWeek) = EntryDT THEN EntryDT
		WHEN dateadd(dd, SatDOW, FirstDayofWeek) = EntryDT THEN EntryDT ELSE NULL END) as RequirementDT,
		WeeklyQty,
		DaysPerWeekShip,
		StdPack,
		(CASE WHEN DaysPerWeekShip = 0 THEN OrderDetail.ODQty
		WHEN dateadd(dd, SunDOW, FirstDayofWeek) = EntryDT THEN (weeklyqty/isNULL(nullif(daysperweekship,0),1))
		WHEN dateadd(dd, MonDOW, FirstDayofWeek) = EntryDT THEN (weeklyqty/isNULL(nullif(daysperweekship,0),1))
		WHEN dateadd(dd, TueDOW, FirstDayofWeek) = EntryDT THEN (weeklyqty/isNULL(nullif(daysperweekship,0),1))
		WHEN dateadd(dd, WedDOW, FirstDayofWeek) = EntryDT THEN (weeklyqty/isNULL(nullif(daysperweekship,0),1))
		WHEN dateadd(dd, ThuDOW, FirstDayofWeek) = EntryDT THEN (weeklyqty/isNULL(nullif(daysperweekship,0),1))
		WHEN dateadd(dd, FriDOW, FirstDayofWeek) = EntryDT THEN (weeklyqty/isNULL(nullif(daysperweekship,0),1))
		WHEN dateadd(dd, SatDOW, FirstDayofWeek) = EntryDT THEN(weeklyqty/isNULL(nullif(daysperweekship,0),1)) ELSE NULL END)  as DailyNoStdPack,
		((weeklyqty/isNULL(nullif(daysperweekship,0),1))/stdPack) as DailyBoxes,
		((weeklyqty/isNULL(nullif(daysperweekship,0),1))/stdPack)*stdPack as DailyPerStdPack,
		Sunday,
		Monday,
		Tuesday,
		Wednesday,
		Thursday,
		Friday,
		Saturday,
		SunDOW,
		MonDOW,
		TueDOW,
		WedDOW,
		ThuDOW,
		FriDOW,
		SatDOW,
		EntryDT,
		ODDueDT,
		ODQty
	
			
from

(Select	max(order_header.destination) DestinationGp,
		order_header.destination,
		(isNULL(SundayShip,0)+isNULL(MondayShip,0)+isNULL(TuesdayShip,0)+isNULL(WednesdayShip,0)+isNULL(ThursdayShip,0)+isNULL(FridayShip,0)+isNULL(SaturdayShip,0)) as DaysPerWeekShip,
		(CASE WHEN isNULL(SundayShip,0) = 1 THEN 1 ELSE 0 END) as Sunday,
		(CASE WHEN isNULL(MondayShip,0) = 1 THEN 1 ELSE 0 END) as Monday,
		(CASE WHEN isNULL(TuesdayShip,0) = 1 THEN 1 ELSE 0 END) as Tuesday,
		(CASE WHEN isNULL(WednesdayShip,0) = 1 THEN 1 ELSE 0 END) as Wednesday,
		(CASE WHEN isNULL(ThursdayShip,0) = 1 THEN 1 ELSE 0 END) as Thursday,
		(CASE WHEN isNULL(FridayShip,0) = 1 THEN 1 ELSE 0 END) as Friday,
		(CASE WHEN isNULL(SaturdayShip,0) = 1 THEN 1 ELSE 0 END) as Saturday,
		(CASE WHEN isNULL(SundayShip,0) = 0 THEN -1 ELSE 0 END) as SunDOW ,
		(CASE WHEN isNULL(MondayShip,0) = 0 THEN -1 ELSE 1 END) as MonDOW,
		(CASE WHEN isNULL(TuesdayShip,0) = 0 THEN -1 ELSE 2 END) as TueDOW,
		(CASE WHEN isNULL(WednesdayShip,0) = 0 THEN -1 ELSE 3 END) as WedDOW,
		(CASE WHEN isNULL(ThursdayShip,0) = 0 THEN -1 ELSE 4 END) as ThuDOW,
		(CASE WHEN isNULL(FridayShip,0) = 0 THEN -1 ELSE 5 END) as FriDOW,
		(CASE WHEN isNULL(SaturdayShip,0) = 0 THEN -1 ELSE 6 END) as SatDOW
		
from		order_detail
join		order_header on order_detail.destination = order_header.destination
join		destination_shipping on order_header.destination = destination_shipping.destination
join		part_inventory on order_detail.part_number = part_inventory.part
group	by	
		order_header.destination,
		(isNULL(SundayShip,0)+isNULL(MondayShip,0)+isNULL(TuesdayShip,0)+isNULL(WednesdayShip,0)+isNULL(ThursdayShip,0)+isNULL(FridayShip,0)+isNULL(SaturdayShip,0)) ,
		(CASE WHEN isNULL(SundayShip,0) = 1 THEN 'Sunday' ELSE '' END) ,
		(CASE WHEN isNULL(MondayShip,0) = 1 THEN 'Monday' ELSE '' END) ,
		(CASE WHEN isNULL(TuesdayShip,0) = 1 THEN 'Tuesday' ELSE '' END) ,
		(CASE WHEN isNULL(WednesdayShip,0) = 1 THEN 'Wednesday' ELSE '' END),
		(CASE WHEN isNULL(ThursdayShip,0) = 1 THEN 'Thursday' ELSE '' END),
		(CASE WHEN isNULL(FridayShip,0) = 1 THEN 'Friday' ELSE '' END) ,
		(CASE WHEN isNULL(SaturdayShip,0) = 1 THEN 'Saturday' ELSE '' END),
		(CASE WHEN isNULL(SundayShip,0) = 1 THEN 1 ELSE 0 END) ,
		(CASE WHEN isNULL(MondayShip,0) = 1 THEN 1 ELSE 0 END),
		(CASE WHEN isNULL(TuesdayShip,0) = 1 THEN 1 ELSE 0 END),
		(CASE WHEN isNULL(WednesdayShip,0) = 1 THEN 1 ELSE 0 END),
		(CASE WHEN isNULL(ThursdayShip,0) = 1 THEN 1 ELSE 0 END),
		(CASE WHEN isNULL(FridayShip,0) = 1 THEN 1 ELSE 0 END),
		(CASE WHEN isNULL(SaturdayShip,0) = 1 THEN 1 ELSE 0 END),
		SundayShip,
		MondayShip,
		TuesdayShip,
		WednesdayShip,
		ThursdayShip,
		FridayShip,
		SaturdayShip
		) ShipDays join (	Select	order_no,
								part_number,
								destination,
								FT.fn_TruncDate( 'wk',due_date) as FirstDayofWeek,
								dateadd(ss, 604799, FT.fn_TruncDate( 'wk',due_date)) as lastDTofweek,
								sum(eeiqty) WeeklyQty,
								isNULL(standard_pack,1) StdPack
						from		order_detail
						join		part_inventory on order_detail.part_number = part_inventory.part
						where	due_date > '2008-01-01'
						group by	order_no,
								destination,
								datediff(wk,FT.fn_DTGlobal('BaseWeek'),due_date),
								part_number,
								FT.fn_TruncDate( 'wk',due_date),
								dateadd(ss, 604799, FT.fn_TruncDate( 'wk',due_date)),
								isNULL(standard_pack,1) 	) WeeklyOrders on Shipdays.Destination = WeeklyOrders.destination
		join (Select	EntryDT  
			from		[dbo].[fn_Calendar_StartCurrentSunday] (Null,'dd',1,365)) DailyCalendar on WeeklyOrders.FirstDayofWeek<= DailyCalendar.EntryDT and WeeklyOrders.lastDTofweek>DailyCalendar.EntryDT
	left  join	( Select	sum(eeiqty) as ODQty,
					due_date as ODDueDT,
					part_number,
					order_no
			from		order_detail
			group by	due_date,
					part_number,
					order_no) OrderDetail on  WeeklyOrders.order_no = OrderDetail.order_no and WeeklyOrders.part_number = Orderdetail.part_number and DailyCalendar.EntryDT = ODDueDT
	where	(CASE WHEN DaysPerWeekShip = 0 THEN OrderDetail.ODDueDT 
		WHEN dateadd(dd, SunDOW, FirstDayofWeek) = EntryDT THEN EntryDT
		WHEN dateadd(dd, MonDOW, FirstDayofWeek) = EntryDT THEN EntryDT
		WHEN dateadd(dd, TueDOW, FirstDayofWeek) = EntryDT THEN EntryDT
		WHEN dateadd(dd, WedDOW, FirstDayofWeek) = EntryDT THEN EntryDT
		WHEN dateadd(dd, ThuDOW, FirstDayofWeek) = EntryDT THEN EntryDT
		WHEN dateadd(dd, FriDOW, FirstDayofWeek) = EntryDT THEN EntryDT
		WHEN dateadd(dd, SatDOW, FirstDayofWeek) = EntryDT THEN EntryDT ELSE NULL END) is not null
union

Select							
								
								destination,
								order_no,
								part_number,
								 PAstDueDate as FirstDayofWeek,
								 sum(eeiqty) WeeklyQty,
								0,
								isNULL(part_inventory.standard_pack,1),
								sum(eeiqty) ,
								0,
								0,
								0,
								0,
								0,
								0,
								0,
								0,
								0,
								0,
								0,
								0,
								0,
								0,
								0,
								0,
								 PAstDueDate,
								 PAstDueDate,
								 sum(eeiqty)
						from		order_detail
						join		part_inventory on order_detail.part_number = part_inventory.part
						cross join	(Select	dateadd(dd,-1,EntryDT)  PAstDueDate
																	from		[dbo].[fn_Calendar_StartCurrentSunday] (Null,'dd',1,1)) pastDueDT
						where	due_date > '2008-01-01' and due_date<(Select	EntryDT  
																	from		[dbo].[fn_Calendar_StartCurrentSunday] (Null,'dd',1,1))
						group by	order_no,
								destination,
								PAstDueDate,
								part_number,
								isNULL(standard_pack,1)
GO

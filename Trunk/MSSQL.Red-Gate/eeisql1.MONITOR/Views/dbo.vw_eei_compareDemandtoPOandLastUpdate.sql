SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[vw_eei_compareDemandtoPOandLastUpdate]
	as		
select	Part = IsNull (SalesOrder.Part, Schedule.Part),		
	FirstDueDT,		
	LastDueDT,		
	WeeklySalesOrderRate,		
	[8WeekWeeklySalesOrderRate],		
	WeeklyScheduleRate,		
	Ratio = WeeklyScheduleRate / WeeklySalesOrderRate,		
	ShortTermRatio = WeeklyScheduleRate / nullif ([8WeekWeeklySalesOrderRate], 0),		
	ScheduleQty,		
	ScheduleCoverageDT = dateadd (day, 7 * ScheduleQty / WeeklySalesOrderRate, getdate ()),		
	LastSchedDT,
	LastUpdated= po_header.date_due,
	CloseOutDate = part_eecustom.prod_end	
from	(	select	Part = left (part_number, 7),
			WeeklySalesOrderRate = sum (quantity) / datediff (week, getdate(), max (due_date)) + 1,
			[8WeekWeeklySalesOrderRate] = sum (case when datediff (week, getdate(), due_date) < 8 then quantity else 0 end) / datediff (week, getdate(), max (case when datediff (week, getdate(), due_date) < 8 then due_date end)) + 1,
			FirstDueDT = min (due_date),
			LastDueDT = max (due_date)
		from	order_detail
		where	due_date > getdate ()
		group by	
			left (part_number, 7)) SalesOrder
	full join		
	(	select	Part = left (part_number, 7),
			WeeklyScheduleRate = sum (balance) / datediff (week, getdate(), max (date_due)) + 1,
			ScheduleQty = sum (balance),
			LastSchedDT = max (date_due)
		from	po_detail
		where	date_due > getdate ()
		group by	
			left (part_number, 7)) Schedule on SalesOrder.Part = Schedule.Part
		left outer join po_header on IsNull (SalesOrder.Part, Schedule.Part) = po_header.blanket_part
		join		part_eecustom on IsNull (SalesOrder.Part, Schedule.Part) = part_eecustom.part
--order by			
	--IsNull (WeeklyScheduleRate / isnull (WeeklySalesOrderRate, .01), 100) desc		
GO

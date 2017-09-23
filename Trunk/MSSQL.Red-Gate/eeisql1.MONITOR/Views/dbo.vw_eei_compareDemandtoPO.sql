SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view  [dbo].[vw_eei_compareDemandtoPO]
as
select	Part = IsNull (SalesOrder.Part, Schedule.Part),		
	FirstDueDT,		
	LastDueDT,		
	WeeklySalesOrderRate,		
	[8WeekWeeklySalesOrderRate],		
	WeeklyScheduleRate,
	[8WeekWeeklyScheduleRate],
	Ratio = WeeklyScheduleRate / nullif (WeeklySalesOrderRate, 0),		
	ShortTermRatio = [8WeekWeeklyScheduleRate] / nullif ([8WeekWeeklySalesOrderRate], 0),		
	ScheduleQty,		
	ScheduleCoverageDT = dateadd (day, 7 * ScheduleQty / WeeklySalesOrderRate, getdate ()),		
	LastSchedDT,
	LastUpdated= Schedule.LastUpdate,
	EOP=SalesOrder.prodend
from	(	select	Part = left (part_number, 7),
			WeeklySalesOrderRate = sum (quantity) / (datediff (week, getdate(), max (due_date)) + 1),
			[8WeekWeeklySalesOrderRate] = sum (case when datediff (week, getdate(), due_date) < 8 then quantity else 0 end) / (datediff (week, getdate(), max (case when datediff (week, getdate(), due_date) < 8 then due_date end)) + 1),
			FirstDueDT = min (due_date),
			LastDueDT = max (due_date),
			prodend = max(part_eecustom.prod_end)
		from	order_detail
			join part_eecustom on order_detail.part_number = part_eecustom.part
			join part_online on order_detail.part_number = part_online.part
		where	due_date > getdate ()
		group by	
			left (part_number, 7)) SalesOrder
	full join		
	(	select	Part = left (part_online.part, 7),
			WeeklyScheduleRate = (isnull (sum (OnHand), 0) + isnull (sum (balance), 0)) / (datediff (week, getdate(), max (PODetail.LastSchedDT)) + 1),
			[8WeekWeeklyScheduleRate] = (isnull (sum (OnHand), 0) + isnull (sum ([8WeekBalance]), 0)) / (datediff (week, getdate(), max (PODetail.[8WeekLastSchedDT])) + 1),
			ScheduleQty = sum (balance),
			LastSchedDT = max (PODetail.LastSchedDT),
			LastUpdate = max(po_header.date_due)
		from	part_online
			join po_header on part_online.part = po_header.blanket_part and
				part_online.default_po_number = po_header.po_number
			left join
			(	select	po_number,
					balance = sum (balance),
					[8WeekBalance] = sum (case when datediff (week, getdate (), po_detail.date_due) < 8 then balance else 0 end),
					LastSchedDT = max (po_detail.date_due),
					[8WeekLastSchedDT] = max (case when datediff (week, getdate (), po_detail.date_due) < 8 then po_detail.date_due end)
				from	po_detail
				where	po_detail.date_due > getdate ()
				group by
					po_number) PODetail on part_online.default_po_number = PODetail.po_number
			left join
			(	select	Part = part,
					OnHand = sum (quantity)
				from	object
				where	status = 'A'
				group by
					part) PartOnline on part_online.part = PartOnline.Part
		group by	
			left (part_online.part, 7)) Schedule on SalesOrder.Part = Schedule.Part
GO

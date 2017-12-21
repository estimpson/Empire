SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [TOPS].[Leg_OpenOrders]
as
select
	od.Part
,	od.DueDT
,	od.Quantity
,	od.WeekNo
,	od.WeekDay
,	MondayDate = dateadd(day, -od.WeekDay + 2, od.DueDT)
from
	(	select
		Part = od.part_number
	,	DueDT = FT.fn_TruncDate('dd', od.due_date)
	,	Quantity = od.quantity
	,	WeekNo = datediff(week, '2001-01-01', od.due_date)
	,	WeekDay = datepart(weekday, od.due_date)
	from
		MONITOR.dbo.order_detail od
	where
		coalesce(od.custom01, 'XXX') != 'ASB'
	) od
GO


/*
Create View.MONITOR.TOPS.Leg_OnOrder.sql
*/

use MONITOR
go

--drop table TOPS.Leg_OnOrder
if	objectproperty(object_id('TOPS.Leg_OnOrder'), 'IsView') = 1 begin
	drop view TOPS.Leg_OnOrder
end
go

create view TOPS.Leg_OnOrder
as
select
	pd.Part
,	pd.PONumber
,	pd.DueDT
,	pd.Balance
,	pd.WeekNo
,	pd.WeekDay
,	MondayDate = dateadd(day, -pd.WeekDay + 2, pd.DueDT)
from
	(	select
			Part = pd.part_number
		,	PONumber = pd.po_number
		,	DueDT = pd.date_due
		,	Balance = pd.balance
		,	WeekNo = datediff(week, '2001-01-01', pd.date_due)
		,	WeekDay = datepart(weekday, pd.date_due)
		from
			MONITOR.dbo.po_detail pd
		where
			pd.vendor_code = 'eeh'
			and coalesce(truck_number, 'XXX') != 'ASB'
			and pd.balance > 0
	) pd
go

select
	*
from
	TOPS.Leg_OnOrder loo
order by
	loo.Part
,	loo.DueDT
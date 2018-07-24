
/*
Create View.MONITOR.TOPS.Leg_TransInventory.sql
*/

use MONITOR
go

--drop table TOPS.Leg_TransInventory
if	objectproperty(object_id('TOPS.Leg_TransInventory'), 'IsView') = 1 begin
	drop view TOPS.Leg_TransInventory
end
go

create view TOPS.Leg_TransInventory
as
select
	Part = o.part
,	InTransDT = dateadd(day, 10, FT.fn_TruncDate('day', o.last_date))
,	InTransQty = sum(o.quantity)
from
	dbo.object o
	join dbo.part p
		on o.part = p.part
	left join dbo.location l
		on o.location = l.code
where
	upper(o.location) like '%TRAN%'
	and p.type = 'F'
	and isnull(o.field2, 'XXX') <> 'ASB'
	and coalesce(l.secured_location, 'N') != 'Y'
group by
	o.part
,	dateadd(day, 10, FT.fn_TruncDate('day', o.last_date))
go

select
	*
from
	TOPS.Leg_TransInventory lti
order by
	lti.Part
go

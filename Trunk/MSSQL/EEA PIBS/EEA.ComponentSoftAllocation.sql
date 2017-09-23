
/*
Create table MONITOR.EEA.ComponentSoftAllocation
*/

use MONITOR
go

--drop table EEA.ComponentSoftAllocation
if	objectproperty(object_id('EEA.ComponentSoftAllocation'), 'IsView') = 1 begin
	drop view EEA.ComponentSoftAllocation
end
go

create view EEA.ComponentSoftAllocation
as
select
	fgn.Part
,	Description = max(p.name)
,	QtyRequired = sum(fgn.GrossDemand)
,	QtyFinished = sum(fgn.WIPQty)
,	QtyAvailable = sum(fgn.OnHandQty)
,	Balance = sum(Balance)
,	RunoutDT = min(case when fgn.Balance > 0 then fgn.RequiredDT end)
,	DaysOnHand = datediff(day, getdate(), min(case when fgn.Balance > 0 then fgn.RequiredDT end))
,	WeekDaysOnHand = min(
	case
		when fgn.Balance > 0
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, fgn.RequiredDT) when 1 then fgn.RequiredDT -2 when 7 then fgn.RequiredDT - 1 else fgn.RequiredDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, fgn.RequiredDT) when 1 then fgn.RequiredDT -2 when 7 then fgn.RequiredDT - 1 else fgn.RequiredDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, fgn.RequiredDT) when 1 then fgn.RequiredDT -2 when 7 then fgn.RequiredDT - 1 else fgn.RequiredDT end) then - 2 else 0 end
	end)
from
	EEA.fn_GetNetout() fgn
	join dbo.part p
		on p.part = fgn.Part
	join dbo.order_detail od
		on od.order_no = fgn.OrderNo
		and od.id = fgn.LineID
	join dbo.part_machine pm
		join dbo.location l
			on l.code = pm.machine
			and l.plant = 'EEA'
		on pm.part = od.part_number
where
	p.commodity = 'COMPONENTS'
group by
	fgn.Part
go

select
	csa.Part
,	csa.Description
,	csa.QtyRequired
,	csa.QtyFinished
,	csa.QtyAvailable
,	csa.Balance
,	csa.RunoutDT
,	csa.DaysOnHand
,	csa.WeekDaysOnHand
from
	EEA.ComponentSoftAllocation csa
order by
	1


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
,	QtyAllocated = coalesce(max(alloc.QtyAllocated), 0)
,	QtyAvailable = sum(fgn.OnHandQty) - coalesce(max(alloc.QtyAllocated), 0)
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
,	ShipDaysOnHand =
	case
		when sum(fgn.Balance) > 0
			then count(distinct case when fgn.Balance = 0 then fgn.RequiredDT end)
		else 9999
	end
,	FinishedPartList = FX.ToList(distinct od.part_number)
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
	outer apply
		(	select
				QtyAllocated = sum(o.std_quantity)
			from
				dbo.object o
			where
				o.part = p.Part
				and o.location in
					(	select
							EEA_M.code
						from
							dbo.location EEA_M
						where
							EEA_M.plant = 'EEA'
							and EEA_M.type = 'MC'
					)
		) alloc
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
,	csa.QtyAllocated
,	csa.QtyAvailable
,	csa.Balance
,	csa.RunoutDT
,	csa.DaysOnHand
,	csa.WeekDaysOnHand
,	csa.ShipDaysOnHand
,	csa.FinishedPartList
from
	EEA.ComponentSoftAllocation csa
where
	'NALB124-ASA03' in
		(	select
				sstr.Value
			from
				dbo.fn_SplitStringToRows(csa.FinishedPartList, ',') sstr
		)
order by
	csa.Part

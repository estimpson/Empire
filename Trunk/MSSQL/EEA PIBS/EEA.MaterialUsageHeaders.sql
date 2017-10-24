
if	objectproperty(object_id('EEA.MaterialUsageHeaders'), 'IsView') = 1 begin
	drop view EEA.MaterialUsageHeaders
end
go

create view EEA.MaterialUsageHeaders
as
select
	EEAParts.Part
,	Description = p.name
,	EEAParts.RunoutDT
,	OnHandApprovedQty = (select sum(std_quantity) from object where part = EEAParts.Part and status = 'A' and location in (select code from location where plant = 'EEA' and coalesce(secured_location, 'N') != 'Y'))
,	OnHandHoldQty = (select sum(std_quantity) from object where part = EEAParts.Part and status = 'H' and location in (select code from location where plant = 'EEA' and coalesce(secured_location, 'N') != 'Y'))
,	SecuredQty = (select sum(std_quantity) from object where part = EEAParts.Part and location in (select code from location where plant = 'EEA' and coalesce(secured_location, 'N') = 'Y'))
,	InTransitQty = (select sum(std_quantity) from object where part = EEAParts.Part and location = 'INTRANSAL')
,	GrossDemand
,	NetWIPDemand
,	NetDemand
from
	(	select
			Part = coalesce(part.part, fgn.Part)
		,	RunoutDT = min(case when fgn.Balance > 0 then fgn.RequiredDT end)
		,	GrossDemand = sum(fgn.GrossDemand)
		,	NetWIPDemand = sum(fgn.Balance + fgn.OnHandQty + fgn.InTransitQty)
		,	NetDemand = sum(fgn.Balance)
		from
			part
			full join EEA.fn_GetNetout() fgn
				on fgn.part = part.part
		where
			part.part in (select part from dbo.object o where location in (select code from location where plant = 'EEA') or location = 'INTRANSAL')
			and
				part.part != 'PALLET'
		group by
			coalesce(part.part, fgn.Part)
	) EEAParts
	join dbo.part p
		on p.part = EEAParts.Part
go

select
	*
from
	EEA.MaterialUsageHeaders
order by
	Part

select
	*
from
	EEA.fn_GetNetout()
order by
	Part
,	RequiredDT

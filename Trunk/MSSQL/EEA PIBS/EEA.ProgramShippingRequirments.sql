
if	objectproperty(object_id('EEA.ProgramShippingRequirements'), 'IsView') = 1 begin
	drop view EEA.ProgramShippingRequirements
end
go

create view EEA.ProgramShippingRequirements
as
select
	ProgramCode
,	BillTo
,	ShipTo
,	InHouseFG
,	InHouseRaw
,	InTransit
,	CurrentBuild
,	NextBuild
,	ShipSched
,	OrderNo
,	DueDT
,	PartCode
,	QtyDue
,	Firm
,	StandardPack
,	Totes
,	QtyFG
,	QtyRaw
,	QtyTrans
,	QtyCurrent
,	QtyNext
,	QtyShip
,	AccumRequired
from
	EEA.fn_ProgramShippingRequirements2() fpsr
go

select
	psr.ProgramCode
,   psr.BillTo
,   psr.ShipTo
,   psr.InHouseFG
,   psr.InHouseRaw
,   psr.InTransit
,   psr.CurrentBuild
,   psr.NextBuild
,   psr.ShipSched
,   psr.OrderNo
,   psr.DueDT
,   psr.PartCode
,   psr.QtyDue
,   psr.Firm
,   psr.StandardPack
,   psr.Totes
,   psr.QtyFG
,   psr.QtyRaw
,   psr.QtyTrans
,   psr.QtyCurrent
,   psr.QtyNext
,   psr.QtyShip
,   psr.AccumRequired
from
	EEA.ProgramShippingRequirements psr
order by
	psr.ProgramCode
,	psr.DueDT
,	psr.OrderNo
go


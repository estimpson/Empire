
if	objectproperty(object_id('EEA.ProgramShippingRequirements'), 'IsView') = 1 begin
	drop view EEA.ProgramShippingRequirements
end
go

create view EEA.ProgramShippingRequirements
as
select
	ProgramCode
,   BillTo
,   ShipTo
,   InHouseFG
,   InHouseRaw
,   InTransit
,   CurrentBuild
,   NextBuild
,   ShipSched
,   OrderNo
,   DueDT
,   PartCode
,   QtyDue
,   Firm
,   StandardPack
,   Totes
,   QtyFG
,   QtyRaw
,   QtyTrans
,   QtyCurrent
,   QtyNext
,   QtyShip
,   AccumRequired
from
	EEA.fn_ProgramShippingRequirements()
go


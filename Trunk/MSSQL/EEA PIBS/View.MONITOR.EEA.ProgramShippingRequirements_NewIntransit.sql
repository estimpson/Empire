
/*
Create View.MONITOR.EEA.ProgramShippingRequirements_NewIntransit.sql
*/

use MONITOR
go

--drop table EEA.ProgramShippingRequirements_NewIntransit
if	objectproperty(object_id('EEA.ProgramShippingRequirements_NewIntransit'), 'IsView') = 1 begin
	drop view EEA.ProgramShippingRequirements_NewIntransit
end
go

create view EEA.ProgramShippingRequirements_NewIntransit
as
select
	fpsr.ProgramCode
,	fpsr.CustomerPart
,	fpsr.BillTo
,	fpsr.ShipTo
,	fpsr.InHouseFG
,	fpsr.InHouseRaw
,	fpsr.InTransit1
,	fpsr.InTransit2
,	fpsr.CurrentBuild
,	fpsr.NextBuild
,	fpsr.ShipSched
,	fpsr.OrderNo
,	fpsr.DueDT
,	fpsr.PartCode
,	fpsr.QtyDue
,	fpsr.Firm
,	fpsr.StandardPack
,	fpsr.Totes
,	fpsr.QtyFG
,	fpsr.QtyRaw
,	fpsr.QtyTrans1
,	fpsr.QtyTrans2
,	fpsr.QtyCurrent
,	fpsr.QtyNext
,	fpsr.QtyShip
,	fpsr.AccumRequired
from
	EEA.fn_ProgramShippingRequirements_NewIntransit() fpsr
go

select
	psr.ProgramCode
,	psr.CustomerPart
,	psr.BillTo
,	psr.ShipTo
,	psr.InHouseFG
,	psr.InHouseRaw
,	psr.InTransit1
,	psr.InTransit2
,	psr.CurrentBuild
,	psr.NextBuild
,	psr.ShipSched
,	psr.OrderNo
,	psr.DueDT
,	psr.PartCode
,	psr.QtyDue
,	psr.Firm
,	psr.StandardPack
,	psr.Totes
,	psr.QtyFG
,	psr.QtyRaw
,	psr.QtyTrans1
,	psr.QtyTrans2
,	psr.QtyCurrent
,	psr.QtyNext
,	psr.QtyShip
,	psr.AccumRequired
from
	EEA.ProgramShippingRequirements_NewIntransit psr

go
declare
	@ProgramCode varchar(7) = 'NAL1022'
,	@ShipTo varchar(20) = 'NALSALEM'

select
	psr.DueDT
,	psr.PartCode
,	psr.QtyDue
,	color =
		case
			when psr.QtyShip >= psr.QtyDue then 'LightBlue'
			when psr.QtyFG >= psr.QtyDue then 'LightGreen'
			when psr.QtyFG + psr.QtyCurrent + psr.QtyNext >= psr.QtyDue then 'Yellow'
			when psr.QtyFG + psr.QtyCurrent + psr.QtyNext >= psr.QtyDue then 'Yellow'
			when psr.QtyFG + psr.QtyCurrent + psr.QtyNext > 0 then 'Orange'
		end
,	psr.Firm
,	psr.StandardPack
,	psr.Totes
,	psr.QtyFG
,	psr.QtyRaw
,	psr.QtyTrans1
,	psr.QtyTrans2
,	psr.QtyCurrent
,	psr.QtyNext
,	psr.QtyShip
,	psr.AccumRequired
from
	EEA.ProgramShippingRequirements_NewIntransit psr
where
	psr.ProgramCode = @ProgramCode
	and psr.ShipTo = @ShipTo
order by
	psr.ProgramCode
,	psr.DueDT
,	psr.OrderNo

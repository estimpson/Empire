SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[FinishedGoodHeaders_NewIntransit]
as
select
	psr.ProgramCode
,	psr.PartCode
,	psr.CustomerPart
,	psr.BillTo
,	psr.ShipTo
,	StandardPack = max(StandardPack)
,	InHouseFG = sum(QtyFG)
,	InHouseRaw = sum(QtyRaw)
,	InTransit1 = sum(QtyTrans1)
,	InTransit2 = sum(QtyTrans2)
,	CurrentBuild = sum(QtyCurrent)
,	NextBuild = sum(QtyNext)
,	ShipSched = sum(QtyShip)
,	DaysFG =
	case
		when sum(psr.QtyFG) < sum(QtyDue)
			then count(distinct case when psr.QtyFG >= psr.QtyDue then psr.DueDT end)
		else 9999
	end
,	DaysRaw =
	case
		when sum(psr.QtyFG + psr.QtyRaw) < sum(QtyDue)
			then count(distinct case when psr.QtyFG + psr.QtyRaw >= psr.QtyDue then psr.DueDT end)
		else 9999
	end
,	DaysTrans1 =
	case
		when sum(psr.QtyFG + psr.QtyRaw + psr.QtyTrans1) < sum(QtyDue)
			then count(distinct case when psr.QtyFG + psr.QtyRaw + psr.QtyTrans1 >= psr.QtyDue then psr.DueDT end)
		else 9999
	end
,	DaysTrans2 =
	case
		when sum(psr.QtyFG + psr.QtyRaw + psr.QtyTrans1 + psr.QtyTrans2) < sum(QtyDue)
			then count(distinct case when psr.QtyFG + psr.QtyRaw + psr.QtyTrans1 + psr.QtyTrans2 >= psr.QtyDue then psr.DueDT end)
		else 9999
	end
,	DaysCurrentSched = 
	case
		when sum(psr.QtyFG + psr.QtyCurrent) < sum(QtyDue)
			then count(distinct case when psr.QtyFG + psr.QtyCurrent >= psr.QtyDue then psr.DueDT end)
		else 9999
	end
,	DaysNextSched =
	case
		when sum(psr.QtyFG + psr.QtyCurrent + psr.QtyNext) < sum(QtyDue)
			then count(distinct case when psr.QtyFG + psr.QtyCurrent + psr.QtyNext >= psr.QtyDue then psr.DueDT end)
		else 9999
	end
,	DaysShipSched =
	case
		when sum(psr.QtyShip) < sum(QtyDue)
			then count(distinct case when psr.QtyShip >= psr.QtyDue then psr.DueDT end)
		else 9999
	end
from
	EEA.ProgramShippingRequirements_NewIntransit psr
group by
	psr.ProgramCode
,	psr.PartCode
,	psr.CustomerPart
,	psr.BillTo
,	psr.ShipTo
GO

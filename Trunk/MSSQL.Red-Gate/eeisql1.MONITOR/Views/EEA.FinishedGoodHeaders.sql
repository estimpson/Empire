SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[FinishedGoodHeaders]
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
,	InTransit = sum(QtyTrans)
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
,	DaysTrans =
	case
		when sum(psr.QtyFG + psr.QtyRaw + psr.QtyTrans) < sum(QtyDue)
			then count(distinct case when psr.QtyFG + psr.QtyRaw + psr.QtyTrans >= psr.QtyDue then psr.DueDT end)
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
,	DaysFG2 = coalesce(min(
	case
		when QtyFG < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end) - 1, 9999)
,	DaysFG1 = coalesce(datediff(day, getdate(), min(case when QtyFG < QtyDue then DueDT end)), 0)
,	DaysRaw2 = coalesce(min(
	case
		when QtyFG + QtyRaw < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end) - 1, 9999)
	
	-
	
	coalesce(min(
	case
		when QtyFG < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end) - 1, 9999)
	
,	DaysRaw1 = coalesce(datediff(day, getdate(), min(case when QtyFG + QtyRaw < QtyDue then DueDT end)), 0)
,	DaysTrans2 = coalesce(min(
	case
		when QtyFG + QtyRaw + QtyTrans < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end) - 1, 9999)
	
	-
	
	coalesce(min(
	case
		when QtyFG + QtyRaw < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end) - 1, 9999)
	
,	DaysTrans1 = coalesce(datediff(day, getdate(), min(case when QtyFG + QtyRaw + QtyTrans < QtyDue then DueDT end)), 0)
,	DaysCurrentSched2 = coalesce(min(
	case
		when QtyFG + QtyCurrent < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end) - 1, 9999)
	
	-
	
	coalesce(min(
	case
		when QtyFG < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end) - 1, 9999)
	
,	DaysCurrentSched1 = coalesce(datediff(day, getdate(), min(case when QtyFG + QtyCurrent < QtyDue then DueDT end)), 0)
,	DaysNextSched2 = coalesce(min(
	case
		when QtyFG + QtyNext < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end) - 1, 9999)
	
	-
	
	coalesce(min(
	case
		when QtyFG < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end) - 1, 9999)
	
,	DaysNextSched1 = coalesce(datediff(day, getdate(), min(case when QtyFG + QtyNext < QtyDue then DueDT end)), 0)
,	DaysShipSched2 = coalesce(min(
	case
		when QtyShip < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end) - 1, 9999)
	
	-
	
	coalesce(min(
	case
		when QtyFG < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end) - 1, 9999)
	
,	DaysShipSched1 = coalesce(datediff(day, getdate(), min(case when QtyShip < QtyDue then DueDT end)), 0)
from
	EEA.ProgramShippingRequirements psr
group by
	psr.ProgramCode
,	psr.PartCode
,	psr.CustomerPart
,	psr.BillTo
,	psr.ShipTo
GO

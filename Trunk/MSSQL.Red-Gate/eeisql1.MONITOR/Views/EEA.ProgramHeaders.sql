SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[ProgramHeaders]
as
select
	ProgramCode
,	PartCode
,	BillTo
,	ShipTo
,	StandardPack = max(StandardPack)
,	InHouseFG = max(InHouseFG)
,	InHouseRaw = max(InHouseRaw)
,	InTransit = max(InTransit)
,	CurrentBuild = sum(QtyCurrent)
,	NextBuild = sum(QtyNext)
,	ShipSched = sum(QtyShip)
,	DaysFG = coalesce(min(
	case
		when QtyFG < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end), 0)
,	DaysFG1 = coalesce(datediff(day, getdate(), min(case when QtyFG < QtyDue then DueDT end)), 0)
,	DaysRaw = coalesce(min(
	case
		when QtyFG + QtyRaw < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end), 0)
,	DaysRaw1 = coalesce(datediff(day, getdate(), min(case when QtyFG + QtyRaw < QtyDue then DueDT end)), 0)
,	DaysTrans = coalesce(min(
	case
		when QtyFG + QtyRaw + QtyTrans < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end), 0)
,	DaysTrans1 = coalesce(datediff(day, getdate(), min(case when QtyFG + QtyRaw + QtyTrans < QtyDue then DueDT end)), 0)
,	DaysCurrentSched = coalesce(min(
	case
		when QtyFG + QtyCurrent < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end), 0)
,	DaysCurrentSched1 = coalesce(datediff(day, getdate(), min(case when QtyFG + QtyCurrent < QtyDue then DueDT end)), 0)
,	DaysNextSched = coalesce(min(
	case
		when QtyFG + QtyNext < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end), 0)
,	DaysNextSched1 = coalesce(datediff(day, getdate(), min(case when QtyFG + QtyNext < QtyDue then DueDT end)), 0)
,	DaysShipSched = coalesce(min(
	case
		when QtyShip < QtyDue
			then
				5 * (datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) / 7)
				+	datediff(day, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) % 7
				+	case when datepart(dw, case datepart(dw, getdate()) when 1 then getdate() + 1 when 7 then getdate() + 2 else getdate() end) > datepart(dw, case datepart(dw, DueDT) when 1 then DueDT -2 when 7 then DueDT - 1 else DueDT end) then - 2 else 0 end
	end), 0)
,	DaysShipSched1 = coalesce(datediff(day, getdate(), min(case when QtyShip < QtyDue then DueDT end)), 0)
from
	EEA.ProgramShippingRequirements
group by
	ProgramCode
,	PartCode
,	BillTo
,	ShipTo
GO

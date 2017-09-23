SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwAVR]
as
select	PONumber = vwPOD.PONumber,
	Part = vwPOD.Part,
	WeekNo = DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), vwPOD.DueDT ),
	DueDT = vwPOD.DueDT,
	LineID = vwPOD.LineID,
	StdQty = vwPOD.StdQty,
	PriorAccum = IsNull ( POReceiptTotals.StdQty + POReceiptTotals.AccumAdjust, 0 ) + IsNull (
	(	select	sum ( POD2.StdQty )
		from	FT.vwPOD POD2
		where	POD2.PONumber = vwPOD.PONumber and
			POD2.Part = vwPOD.Part and
			POD2.DueDT < vwPOD.DueDT ), 0 ),
	AccumReceived = IsNull ( POReceiptTotals.StdQty + POReceiptTotals.AccumAdjust, 0 ),
	LastReceivedDT = POReceiptTotals.LastReceivedDT,
	LastReceivedAmount = POReceiptTotals.LastReceivedAmount,
	FabWeekNo = DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate () ) + Floor ( vwPOD.FABDays / 7 ),
	FabEndDT = DateAdd ( week, DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate () ) + Floor ( vwPOD.FABDays / 7 ), FT.fn_DTGlobal ( 'BaseWeek' ) ),
	RawWeekNo = DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate () ) + Floor ( vwPOD.RawDays / 7 ),
	RawEndDT = DateAdd ( week, DateDiff ( week, FT.fn_DTGlobal ( 'BaseWeek' ), GetDate () ) + Floor ( vwPOD.RawDays / 7 ), FT.fn_DTGlobal ( 'BaseWeek' ) )
from	FT.vwPOD vwPOD
	left outer join FT.POReceiptTotals POReceiptTotals on vwPOD.PONumber = POReceiptTotals.PONumber and
		vwPOD.Part = POReceiptTotals.Part
where	vwPOD.ReleaseControl = 'A' and
	vwPOD.StdQty > 0
GO

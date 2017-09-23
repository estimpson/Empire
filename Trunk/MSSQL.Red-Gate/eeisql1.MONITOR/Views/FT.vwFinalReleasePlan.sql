SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwFinalReleasePlan]
as
select	ReleasePlanID,
	ReceiptPeriodID,
	PONumber,
	Part,
	WeekNo,
	DueDT,
	LineID,
	StdQty,
	PriorAccum,
	PostAccum,
	AccumReceived,
	LastReceivedDT,
	LastReceivedAmount,
	FabWeekNo,
	RawWeekNo
from	FT.ReleasePlanRaw ReleasePlanRaw
where	ReleasePlanID =
	(	select	max ( LastPlan.ReleasePlanID )
		from	FT.ReleasePlanRaw LastPlan
		where	ReleasePlanRaw.PONumber = LastPlan.PONumber and
			ReleasePlanRaw.Part = LastPlan.Part and
			ReleasePlanRaw.WeekNo = LastPlan.WeekNo )
GO

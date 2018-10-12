SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeiSp_rpt_newLeadTimeAccum] (@POnumber int, @EvaluationDate datetime, @LeadTimeWeek datetime)

as

Begin
--eeiSp_rpt_newLeadTimeAccum 24155, '2009-04-26', '2009-04-05'
Select	distinct ft.POReceiptTotals.PONumber,
		ft.POReceiptTotals.Part,
		(Select min(postAccum) from ft.releasePlanRaw RPR  join ft.ReleasePlans RP on RPR.ReleasePlanId = RP.ID where RPR.ReleasePlanID >= ft.ReleasePlanRaw.ReleasePlanID and RPR.DueDT>= @EvaluationDate and RPR.PONumber = ft.ReleasePlanRaw.PONumber and GeneratedDT>= @LeadTimeWeek ) AccumatLeadSent,
		ft.POReceiptTotals.LastReceivedDT,
		ft.POReceiptTotals.StdQty as NonAdjustedAccumReceived,
		AccumAdjust as AccumAdjustment,
		ft.POReceiptTotals.StdQty+AccumAdjust as AdjustedAccumReceived,
		(ft.POReceiptTotals.StdQty+AccumAdjust)-(Select min(postAccum) from ft.releasePlanRaw RPR  join ft.ReleasePlans RP on RPR.ReleasePlanId = RP.ID where RPR.ReleasePlanID >= ft.ReleasePlanRaw.ReleasePlanID and RPR.DueDT>= @EvaluationDate and RPR.PONumber = ft.ReleasePlanRaw.PONumber and GeneratedDT>= @LeadTimeWeek ) as QtyBehind
from		ft.ReleasePlanRaw
join		ft.ReleasePlans on ft.ReleasePlanRaw.ReleasePlanId = ID
left join	ft.POReceiptTotals on ft.ReleasePlanRaw.PONumber  = ft.POReceiptTotals.PONumber and  ft.ReleasePlanRaw.Part  = ft.POReceiptTotals.Part
where	ft.ReleasePlanRaw.PONumber =  @POnumber and
		ft.fn_truncdate('wk', GeneratedDT) >= @LeadTimeWeek

End
GO

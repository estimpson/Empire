SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	view [dbo].[vw_eei_newLeadtime]

as

Select	PONumber,
		Part,
		GeneratedDT,
		DueDT,
		StdQty,
		PriorAccum,
		PostAccum,
		LastReceivedDT,
		(Select min(postAccum) from ft.releasePlanRaw RPR  join ft.ReleasePlans RP on RPR.ReleasePlanId = RP.ID where RPR.ReleasePlanID >= ft.ReleasePlanRaw.ReleasePlanID and RPR.DueDT>= '2009-04-26' and RPR.PONumber = ft.ReleasePlanRaw.PONumber and GeneratedDT>= '2009-04-05' ) AccumatLeadSent
from		ft.ReleasePlanRaw
join		ft.ReleasePlans on ft.ReleasePlanRaw.ReleasePlanId = ID
where	PONumber = 24155 and
		ft.fn_truncdate('wk', GeneratedDT) >=  '2009-04-05' 
GO

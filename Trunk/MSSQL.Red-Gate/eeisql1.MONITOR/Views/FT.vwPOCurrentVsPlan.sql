SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwPOCurrentVsPlan]
as
select	CurrentReleasePlan.ReleasePlanID,
	CurrentReleasePlan.PONumber,
	CurrentReleasePlan.Part,
	CurrentReleasePlan.WeekNo,
	CurrentReleasePlan.StdQty,
	CurrentReleasePlan.PriorAccum,
	CurrentReleasePlan.PostAccum,
	AuthorizedAccum = isnull ( FabAuthorizations.AuthorizedAccum, 0 )
from	FT.CurrentReleasePlan CurrentReleasePlan
	left outer join FT.FabAuthorizations FabAuthorizations on CurrentReleasePlan.PONumber = FabAuthorizations.PONumber and
		CurrentReleasePlan.Part = FabAuthorizations.Part and
		FabAuthorizations.ReleasePlanID =
		(	select	max ( FA2.ReleasePlanID )
			from	FT.FabAuthorizations FA2
			where	CurrentReleasePlan.PONumber = FA2.PONumber and
				CurrentReleasePlan.Part = FA2.Part and
				CurrentReleasePlan.WeekNo >= FA2.WeekNo )
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ReleaseAnalysis] @part varchar(25)
as

SELECT a.ReleasePlanID, 
b.generateddt,
a.OrderNumber, 
a.BasePart,
a.Part, 
a.CurrentWeek,
a.WeekNo, 
a.DueDT, 
a.StdQty, 
a.PriorAccum, 
a.PostAccum, 
a.AccumShipped, 
a.LastShippedDT, 
a.LastShippedAmount, 
a.LastShippedShipper, 
a.FirmWeeks, 
a.FABWeeks, 
a.MATWeeks, 
a.FABAuthorized, 
a.MATAuthorized, 
a.PosAllowedVariancem, 
a.NegAllowedVariance, 
a.EEIEntry, 
a.ReleaseNo, 
a.LineID
FROM MONITOR.dbo.CustomerReleasePlanRaw a join MONITOR.dbo.customerreleaseplans b on a.releaseplanid = b.id 
WHERE a.Part like @part + '%'
order by a.releaseplanid, 
a.duedt
GO

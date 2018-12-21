SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [TOPS].[Analysis_CustSO_Rev1]
as
select
	ReleasePlanID = crp.ID
,	crp.GeneratedDT
,	crp.GeneratedWeekNo
,	crp.GeneratedWeekDay
,	crp.BaseDT
,	crpr.OrderNumber
,	crpr.CurrentWeek
,	crpr.Part
,	crpr.WeekNo
,	crpr.DueDT
,	crpr.LineID
,	crpr.StdQty
,	crpr.PriorAccum
,	crpr.PostAccum
,	crpr.AccumShipped
,	crpr.LastShippedDT
,	crpr.LastShippedAmount
,	crpr.LastShippedShipper
,	crpr.FirmWeeks
,	crpr.FABWeeks
,	crpr.MATWeeks
,	crpr.FABAuthorized
,	crpr.MATAuthorized
,	crpr.PosAllowedVariancem
,	crpr.NegAllowedVariance
,	crpr.EEIEntry
,	crpr.ReleaseNo
,	crpr.BasePart
,	crpr.Destination
from
	dbo.CustomerReleasePlans crp
	join dbo.CustomerReleasePlanRaw crpr
		on crpr.ReleasePlanID = crp.ID
	join dbo.customer cExt
		join dbo.destination d
			on d.customer = cExt.customer
		on d.destination = crpr.Destination
		and coalesce(cExt.region_code, '') != 'INTERNAL'
where
	datepart(weekday, crp.GeneratedDT) = 4
GO

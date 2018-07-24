
declare
	@AnalysisGeneratedWeekNo int = 1007

declare
	@CustomerReleasePlanID int =
		(	select
				max(acsr.ReleasePlanID)
			from
				TOPS.Analysis_CustSO_Rev1 acsr
			where
				acsr.GeneratedWeekNo = @AnalysisGeneratedWeekNo
		)

select
	crpr.ReleasePlanID
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
	left join dbo.customer cExt
		on cExt.customer = crpr.Destination
		and coalesce(cExt.region_code, '') != 'INTERNAL'
where
	crpr.ReleasePlanID = @CustomerReleasePlanID
	and crpr.BasePart like 'SLA%'

select
	*
from
	dbo.order_detail od
where
	od.part_number like 'SLA0346%'

select
	*
from
	dbo.part p
where
	p.part like 'SLA0346%'
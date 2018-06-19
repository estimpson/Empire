
/*
Create View.MONITOR.TOPS.Analysis_CustSO_Rev1.sql
*/

use MONITOR
go

--drop table TOPS.HNPO_Rev1
if	objectproperty(object_id('TOPS.Analysis_CustSO_Rev1'), 'IsView') = 1 begin
	drop view TOPS.Analysis_CustSO_Rev1
end
go

create view TOPS.Analysis_CustSO_Rev1
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
go


select
	acsr.ReleasePlanID
,	acsr.GeneratedWeekNo
,	BasePartCount = count(distinct acsr.BasePart)
,	BasePartList = FX.ToList(distinct acsr.BasePart)
,	acsr.Destination
from
	TOPS.Analysis_CustSO_Rev1 acsr
where
	acsr.GeneratedWeekNo > 1000
group by
	acsr.ReleasePlanID
,	acsr.GeneratedWeekNo
,	acsr.Destination
order by
	1
go



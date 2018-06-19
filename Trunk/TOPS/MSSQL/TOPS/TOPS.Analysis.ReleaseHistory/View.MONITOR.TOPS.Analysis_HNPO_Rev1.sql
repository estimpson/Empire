
/*
Create View.MONITOR.TOPS.Analysis_HNPO_Rev1.sql
*/

use MONITOR
go

--drop table TOPS.HNPO_Rev1
if	objectproperty(object_id('TOPS.Analysis_HNPO_Rev1'), 'IsView') = 1 begin
	drop view TOPS.Analysis_HNPO_Rev1
end
go

create view TOPS.Analysis_HNPO_Rev1
as
select
	ReleasePlanID = rp.ID
,	rp.GeneratedDT
,	rp.GeneratedWeekNo
,	rp.GeneratedWeekDay
,	rp.BaseDT
,	rpr.ReceiptPeriodID
,	rpr.PONumber
,	BasePart = left(rpr.Part, 7)
,	rpr.Part
,	rpr.WeekNo
,	rpr.DueDT
,	rpr.LineID
,	rpr.StdQty
,	rpr.PriorAccum
,	rpr.PostAccum
,	rpr.AccumReceived
,	rpr.LastReceivedDT
,	rpr.LastReceivedAmount
,	rpr.FabWeekNo
,	rpr.RawWeekNo
,	ProductLine = p.product_line
,	StandardPack = pInv.standard_pack
,	Price = ps.cost_cum
from
	FT.ReleasePlans rp
	join FT.ReleasePlanRaw rpr
		join dbo.part p
			on p.part = rpr.Part
		join dbo.part_inventory pInv
			on pInv.part = rpr.Part
		join dbo.part_standard ps
			on ps.part = rpr.Part
		join dbo.po_header phEEH
			on rpr.PONumber = phEEH.po_number
			and phEEH.vendor_code = 'EEH'
		on rpr.ReleasePlanID = rp.ID
where
	datepart(weekday, rp.GeneratedDT) = 4
go

select
	hr.ReleasePlanID
,	hr.GeneratedWeekNo
,	BasePartCount = count(distinct hr.BasePart)
,	BasePartList = FX.ToList(distinct hr.BasePart)
from
	TOPS.Analysis_HNPO_Rev1 hr
group by
	hr.ReleasePlanID
,	hr.GeneratedWeekNo
order by
	1
go


SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [TOPS].[usp_Analysis_WeeklyManufacturingFluctuation]
	@AnalysisGeneratedWeekNo int
as
declare
	@TranDT datetime = null
,	@Result integer = null

set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. TOPS.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
/*	Get intransit inventory */
declare
	@ScheduleDT datetime = convert(datetime, '1999-01-03') + @AnalysisGeneratedWeekNo * 7 + 3

declare
	@OH_DT datetime =
		(	select
				min(ohd.Time_stamp)
			from
				HistoricalData.dbo.object_historical_daily ohd
			where
				ohd.Time_stamp > @ScheduleDT
				and ohd.reason = 'DAILY'
		)

declare
	@InTransitInventory table
(	BasePart char(7)
,	IntransitDT datetime
,	Quantity numeric(20,6)
,	primary key
	(	BasePart
	,	IntransitDT
	)
)

insert
	@InTransitInventory
(	BasePart
,	IntransitDT
,	Quantity
)
select
	BasePart = left(ohd.part, 7)
,	IntransitDT = FT.fn_TruncDate('week', dateadd(day, 10, ohd.last_date)) + 1
,	Quantity = sum(ohd.std_quantity)
from
	HistoricalData.dbo.object_historical_daily ohd
	join dbo.part p
		on ohd.part = p.part
where
	ohd.Time_stamp = @OH_DT
	and ohd.reason = 'DAILY'
	and ohd.location like '%TRAN%'
	and p.type = 'F'
	and isnull(ohd.field2, 'XXX') <> 'ASB'
	and ohd.location not in
		(
			select
				l.code
			from
				dbo.location l
			where
				coalesce(l.secured_location, 'N') = 'Y'
		)
	--and ohd.part like 'ACH0020%'
group by
	left(ohd.part, 7)
,	FT.fn_TruncDate('week', dateadd(day, 10, ohd.last_date)) + 1
order by
	1

/*	Get onhand inventory. */
declare
	@OnhandInventory table
(	BasePart char(7)
,	Quantity numeric(20,6)
,	primary key
	(	BasePart
	)
)

insert
	@OnhandInventory
(	BasePart
,	Quantity
)
select
	BasePart = left(ohd.part, 7)
,	Quantity = sum(ohd.std_quantity)
from
	HistoricalData.dbo.object_historical_daily ohd
	join dbo.part p
		on ohd.part = p.part
where
	ohd.Time_stamp = @OH_DT
	and ohd.reason = 'DAILY'
	and ohd.location not like '%TRAN%'
	and ohd.location not like '%lost%'
	and p.type = 'F'
	and ohd.location not in
		(
			select
				l.code
			from
				dbo.location l
			where
				coalesce(l.secured_location, 'N') = 'Y'
		)
	--and ohd.part like 'ACH0020%'
group by
	left(ohd.part, 7)
order by
	1

/*	Get vendor releases. */
declare
	@VendorReleasePlanID int =
		(	select
				max(ahr.ReleasePlanID)
			from
				TOPS.Analysis_HNPO_Rev1 ahr
			where
				ahr.GeneratedWeekNo = @AnalysisGeneratedWeekNo
		)

declare
	@ManufacturingFluctuationRaw table
(	ReleasePlanID int
,	GeneratedWeekNo int
,	BasePart char(7)
,	ProductLine varchar(25)
,	StandardPack numeric(20,6)
,	OnHandQty numeric(20,6)
,	WeekNo int
,	StdQty numeric(20,6)
,	NextStdQty numeric(20,6)
,	Change numeric(20,6)
,	Price numeric(20,6)
,	primary key
	(	ReleasePlanID
	,	GeneratedWeekNo
	,	BasePart
	,	WeekNo
	)
)

insert
	@ManufacturingFluctuationRaw
(	ReleasePlanID
,	GeneratedWeekNo
,	BasePart
,	ProductLine
,	StandardPack
,	OnHandQty
,	WeekNo
,	StdQty
,	NextStdQty
,	Change
,	Price
)
select
	ahr.ReleasePlanID
,	ahr.GeneratedWeekNo
,	ahr.BasePart
,	ProductLine = max(ahr.ProductLine)
,	StandardPack = max(ahr.StandardPack)
,	OnHandQty = coalesce
		(	(	select
					max(oi.Quantity)
				from
					@OnhandInventory oi
				where
					oi.BasePart = ahr.BasePart
			)
		,	0
		)
,	ahr.WeekNo
,	StdQty = coalesce(max(ahr.PostAccum) - min(ahr.PriorAccum), 0)
,	NextStdQty = coalesce(max(ahrNext.PostAccum) - min(ahrNext.PriorAccum), 0)
,	Change = coalesce((coalesce(max(ahrNext.PostAccum) - min(ahrNext.PriorAccum), 0) - coalesce(max(ahr.PostAccum) - min(ahr.PriorAccum), 0)) / nullif(max(ahr.PostAccum) - min(ahr.PriorAccum), 0), -1)
,	Price = max(ahr.Price)
from
	TOPS.Analysis_HNPO_Rev1 ahr
	left join TOPS.Analysis_HNPO_Rev1 ahrNext
		on ahrNext.ReleasePlanID = ahr.ReleasePlanID
		and ahrNext.BasePart = ahr.BasePart
		and ahrNext.WeekNo = ahr.WeekNo + 1
where
	ahr.ReleasePlanID = @VendorReleasePlanID
group by
	ahr.ReleasePlanID
,	ahr.GeneratedWeekNo
,	ahr.BasePart
,	ahr.WeekNo
order by
	ahr.BasePart
,	ahr.WeekNo

/*	Get customer releases. */
declare
	@CustomerReleasePlanID int =
		(	select
				max(acsr.ReleasePlanID)
			from
				TOPS.Analysis_CustSO_Rev1 acsr
			where
				acsr.GeneratedWeekNo = @AnalysisGeneratedWeekNo
		)

declare
	@CustomerFluctuationRaw table
(	ReleasePlanID int
,	GeneratedWeekNo int
,	BasePart char(7)
,	WeekNo int
,	StdQty numeric(20,6)
,	NextStdQty numeric(20,6)
,	Change numeric(20,6)
,	primary key
	(	ReleasePlanID
	,	GeneratedWeekNo
	,	BasePart
	,	WeekNo
	)
)

;with WeeklyCustSO
(	ReleasePlanID, GeneratedWeekNo, BasePart, WeekNo, StdQty)
as
(	select
		acsr.ReleasePlanID
	,	acsr.GeneratedWeekNo
	,	acsr.BasePart
	,	acsr.WeekNo
	,	StdQty = sum(acsr.StdQty)
	from
		TOPS.Analysis_CustSO_Rev1 acsr
	where
		acsr.ReleasePlanID = @CustomerReleasePlanID
	group by
		acsr.ReleasePlanID
	,	acsr.GeneratedWeekNo
	,	acsr.BasePart
	,	acsr.WeekNo
)
insert
	@CustomerFluctuationRaw
(	ReleasePlanID
,	GeneratedWeekNo
,	BasePart
,	WeekNo
,	StdQty
,	NextStdQty
,	Change
)
select
	wco.ReleasePlanID
,	wco.GeneratedWeekNo
,	wco.BasePart
,	wco.WeekNo
,	StdQty = wco.StdQty
,	NextStdQty = coalesce(wcoNext.StdQty, 0)
,	Change = coalesce((coalesce(wcoNext.StdQty, 0) - coalesce(wco.StdQty, 0)) / nullif(wco.StdQty, 0), -1)
from
	WeeklyCustSO wco
	left join WeeklyCustSO wcoNext
		on wcoNext.BasePart = wco.BasePart
		and wcoNext.WeekNo = wco.WeekNo + 1

/*
insert
	@CustomerFluctuationRaw
(	ReleasePlanID
,	GeneratedWeekNo
,	BasePart
,	WeekNo
,	StdQty
,	NextStdQty
,	Change
)
select
	acsr.ReleasePlanID
,	acsr.GeneratedWeekNo
,	acsr.BasePart
,	acsr.WeekNo
,	StdQty = coalesce(max(acsr.PostAccum) - min(acsr.PriorAccum), 0)
,	NextStdQty = coalesce(max(acsrNext.PostAccum) - min(acsrNext.PriorAccum), 0)
,	Change = coalesce((coalesce(max(acsrNext.PostAccum) - min(acsrNext.PriorAccum), 0) - coalesce(max(acsr.PostAccum) - min(acsr.PriorAccum), 0)) / nullif(max(acsr.PostAccum) - min(acsr.PriorAccum), 0), -1)
from
	TOPS.Analysis_CustSO_Rev1 acsr
	left join TOPS.Analysis_CustSO_Rev1 acsrNext
		on acsrNext.ReleasePlanID = acsr.ReleasePlanID
		and acsrNext.BasePart = acsr.BasePart
		and acsrNext.WeekNo = acsr.WeekNo + 1
where
	acsr.ReleasePlanID = @CustomerReleasePlanID
group by
	acsr.ReleasePlanID
,	acsr.GeneratedWeekNo
,	acsr.BasePart
,	acsr.WeekNo
order by
	acsr.BasePart
,	acsr.WeekNo
*/

/*	Get ship history. */
declare
	@ShipHistory table
(	BasePart char(7)
,	WeekNo int
,	ShipQty numeric(20,6)
,	primary key
	(	BasePart
	,	WeekNo
	)
)

insert
	@ShipHistory
(	BasePart
,	WeekNo
,	ShipQty
)
select
	BasePart = left(sd.part_original, 7)
,	WeekNo = datediff(week, '1999-01-03', s.date_shipped)
,	ShipQty = sum(sd.qty_packed)
from
	(	select
			mfr.ReleasePlanID
		,	mfr.GeneratedWeekNo
		,	mfr.BasePart
		from
			@ManufacturingFluctuationRaw mfr
		group by
			mfr.ReleasePlanID
		,	mfr.GeneratedWeekNo
		,	mfr.BasePart
	) mfr
	join dbo.shipper s
		join dbo.shipper_detail sd
			on sd.shipper = s.id
		on datediff(week, '1999-01-03', s.date_shipped) between mfr.GeneratedWeekNo and mfr.GeneratedWeekNo + 30
		and coalesce(s.type, 'N') in ('N', 'M')
		and left(sd.part_original, 7) = mfr.BasePart
group by
	left(sd.part_original, 7)
,	datediff(week, '1999-01-03', s.date_shipped)

/*	Build and return result set. */
select
	mfr.ReleasePlanID
,	mfr.GeneratedWeekNo
,	mfr.BasePart
,	ProductLine = max(mfr.ProductLine)
,	StandardPack = max(mfr.StandardPack)
,	Price = max(mfr.Price)
,	LineType = '0. IN TRANSIT'

,	StdDev = max(mfr.StdDev)
,	OnHandQty = max(mfr.OnHandQty)

,	Week00Qty = coalesce(max(case when datediff(week, @ScheduleDT, iti.IntransitDT) = 0 then iti.Quantity end), 0)
,	Week01Qty = coalesce(max(case when datediff(week, @ScheduleDT, iti.IntransitDT) = 1 then iti.Quantity end), 0)
,	Week02Qty = 0
,	Week03Qty = 0
,	Week04Qty = 0
,	Week05Qty = 0
,	Week06Qty = 0
,	Week07Qty = 0
,	Week08Qty = 0
,	Week09Qty = 0

,	Week10Qty = 0
,	Week11Qty = 0
,	Week12Qty = 0
,	Week13Qty = 0
,	Week14Qty = 0
,	Week15Qty = 0
,	Week16Qty = 0
,	Week17Qty = 0
,	Week18Qty = 0
,	Week19Qty = 0

,	Week20Qty = 0
,	Week21Qty = 0
,	Week22Qty = 0
,	Week23Qty = 0
,	Week24Qty = 0
,	Week25Qty = 0
,	Week26Qty = 0
,	Week27Qty = 0
,	Week28Qty = 0
,	Week29Qty = 0

,	Week30Qty = 0
,	Week31Qty = 0
,	Week32Qty = 0
,	Week33Qty = 0
,	Week34Qty = 0
,	Week35Qty = 0
,	Week36Qty = 0
,	Week37Qty = 0
,	Week38Qty = 0
,	Week39Qty = 0

,	Week00Delta = 0
,	Week01Delta = 0
,	Week02Delta = 0
,	Week03Delta = 0
,	Week04Delta = 0
,	Week05Delta = 0
,	Week06Delta = 0
,	Week07Delta = 0
,	Week08Delta = 0
,	Week09Delta = 0

,	Week10Delta = 0
,	Week11Delta = 0
,	Week12Delta = 0
,	Week13Delta = 0
,	Week14Delta = 0
,	Week15Delta = 0
,	Week16Delta = 0
,	Week17Delta = 0
,	Week18Delta = 0
,	Week19Delta = 0

,	Week20Delta = 0
,	Week21Delta = 0
,	Week22Delta = 0
,	Week23Delta = 0
,	Week24Delta = 0
,	Week25Delta = 0
,	Week26Delta = 0
,	Week27Delta = 0
,	Week28Delta = 0
,	Week29Delta = 0

,	Week30Delta = 0
,	Week31Delta = 0
,	Week32Delta = 0
,	Week33Delta = 0
,	Week34Delta = 0
,	Week35Delta = 0
,	Week36Delta = 0
,	Week37Delta = 0
,	Week38Delta = 0
,	Week39Delta = 0
from
	(	select
			mfr.ReleasePlanID
		,	mfr.GeneratedWeekNo
		,	mfr.BasePart
		,	ProductLine = max(mfr.ProductLine)
		,	StandardPack = max(mfr.StandardPack)
		,	Price = max(mfr.Price)
		,	StdDev = coalesce(stdev(nullif(mfr.Change, 0)), 0) * coalesce(avg(nullif(mfr.StdQty, 0)), 0) * max(mfr.Price)
		,	OnHandQty = max(mfr.OnHandQty)
		from
			@ManufacturingFluctuationRaw mfr
		group by
			mfr.ReleasePlanID
		,	mfr.GeneratedWeekNo
		,	mfr.BasePart
	) mfr
	left join @InTransitInventory iti
		on iti.BasePart = mfr.BasePart
group by
	mfr.ReleasePlanID
,	mfr.GeneratedWeekNo
,	mfr.BasePart

union all

select
	mfr.ReleasePlanID
,	mfr.GeneratedWeekNo
,	mfr.BasePart
,	ProductLine = max(mfr.ProductLine)
,	StandardPack = max(mfr.StandardPack)
,	Price = max(mfr.Price)
,	LineType = '1. EEI PO REV 1'

,	StdDev = coalesce(stdev(nullif(mfr.Change, 0)), 0) * coalesce(avg(nullif(mfr.StdQty, 0)), 0) * max(mfr.Price)
,	OnHandQty = max(mfr.OnHandQty)

,	Week00Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 0 then mfr.StdQty end), 0)
,	Week01Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 1 then mfr.StdQty end), 0)
,	Week02Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 2 then mfr.StdQty end), 0)
,	Week03Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 3 then mfr.StdQty end), 0)
,	Week04Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 4 then mfr.StdQty end), 0)
,	Week05Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 5 then mfr.StdQty end), 0)
,	Week06Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 6 then mfr.StdQty end), 0)
,	Week07Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 7 then mfr.StdQty end), 0)
,	Week08Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 8 then mfr.StdQty end), 0)
,	Week09Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 9 then mfr.StdQty end), 0)

,	Week10Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 10 then mfr.StdQty end), 0)
,	Week11Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 11 then mfr.StdQty end), 0)
,	Week12Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 12 then mfr.StdQty end), 0)
,	Week13Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 13 then mfr.StdQty end), 0)
,	Week14Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 14 then mfr.StdQty end), 0)
,	Week15Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 15 then mfr.StdQty end), 0)
,	Week16Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 16 then mfr.StdQty end), 0)
,	Week17Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 17 then mfr.StdQty end), 0)
,	Week18Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 18 then mfr.StdQty end), 0)
,	Week19Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 19 then mfr.StdQty end), 0)

,	Week20Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 20 then mfr.StdQty end), 0)
,	Week21Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 21 then mfr.StdQty end), 0)
,	Week22Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 22 then mfr.StdQty end), 0)
,	Week23Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 23 then mfr.StdQty end), 0)
,	Week24Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 24 then mfr.StdQty end), 0)
,	Week25Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 25 then mfr.StdQty end), 0)
,	Week26Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 26 then mfr.StdQty end), 0)
,	Week27Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 27 then mfr.StdQty end), 0)
,	Week28Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 28 then mfr.StdQty end), 0)
,	Week29Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 29 then mfr.StdQty end), 0)

,	Week30Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 30 then mfr.StdQty end), 0)
,	Week31Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 31 then mfr.StdQty end), 0)
,	Week32Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 32 then mfr.StdQty end), 0)
,	Week33Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 33 then mfr.StdQty end), 0)
,	Week34Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 34 then mfr.StdQty end), 0)
,	Week35Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 35 then mfr.StdQty end), 0)
,	Week36Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 36 then mfr.StdQty end), 0)
,	Week37Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 37 then mfr.StdQty end), 0)
,	Week38Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 38 then mfr.StdQty end), 0)
,	Week39Qty = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 39 then mfr.StdQty end), 0)

,	Week00Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 0 then mfr.Change end), 0)
,	Week01Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 1 then mfr.Change end), 0)
,	Week02Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 2 then mfr.Change end), 0)
,	Week03Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 3 then mfr.Change end), 0)
,	Week04Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 4 then mfr.Change end), 0)
,	Week05Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 5 then mfr.Change end), 0)
,	Week06Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 6 then mfr.Change end), 0)
,	Week07Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 7 then mfr.Change end), 0)
,	Week08Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 8 then mfr.Change end), 0)
,	Week09Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 9 then mfr.Change end), 0)

,	Week10Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 10 then mfr.Change end), 0)
,	Week11Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 11 then mfr.Change end), 0)
,	Week12Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 12 then mfr.Change end), 0)
,	Week13Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 13 then mfr.Change end), 0)
,	Week14Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 14 then mfr.Change end), 0)
,	Week15Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 15 then mfr.Change end), 0)
,	Week16Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 16 then mfr.Change end), 0)
,	Week17Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 17 then mfr.Change end), 0)
,	Week18Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 18 then mfr.Change end), 0)
,	Week19Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 19 then mfr.Change end), 0)

,	Week20Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 20 then mfr.Change end), 0)
,	Week21Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 21 then mfr.Change end), 0)
,	Week22Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 22 then mfr.Change end), 0)
,	Week23Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 23 then mfr.Change end), 0)
,	Week24Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 24 then mfr.Change end), 0)
,	Week25Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 25 then mfr.Change end), 0)
,	Week26Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 26 then mfr.Change end), 0)
,	Week27Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 27 then mfr.Change end), 0)
,	Week28Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 28 then mfr.Change end), 0)
,	Week29Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 29 then mfr.Change end), 0)

,	Week30Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 30 then mfr.Change end), 0)
,	Week31Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 31 then mfr.Change end), 0)
,	Week32Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 32 then mfr.Change end), 0)
,	Week33Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 33 then mfr.Change end), 0)
,	Week34Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 34 then mfr.Change end), 0)
,	Week35Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 35 then mfr.Change end), 0)
,	Week36Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 36 then mfr.Change end), 0)
,	Week37Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 37 then mfr.Change end), 0)
,	Week38Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 38 then mfr.Change end), 0)
,	Week39Delta = coalesce(max(case when mfr.WeekNo - mfr.GeneratedWeekNo = 39 then mfr.Change end), 0)
from
	@ManufacturingFluctuationRaw mfr
group by
	mfr.ReleasePlanID
,	mfr.GeneratedWeekNo
,	mfr.BasePart

union all

select
	mfr.ReleasePlanID
,	mfr.GeneratedWeekNo
,	mfr.BasePart
,	ProductLine = max(mfr.ProductLine)
,	StandardPack = max(mfr.StandardPack)
,	Price = max(mfr.Price)
,	LineType = '2. CUST SO'

,	StdDev = max(mfr.StdDev)
,	OnHandQty = max(mfr.OnHandQty)

,	Week00Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 0 then cfr.StdQty end), 0)
,	Week01Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 1 then cfr.StdQty end), 0)
,	Week02Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 2 then cfr.StdQty end), 0)
,	Week03Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 3 then cfr.StdQty end), 0)
,	Week04Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 4 then cfr.StdQty end), 0)
,	Week05Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 5 then cfr.StdQty end), 0)
,	Week06Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 6 then cfr.StdQty end), 0)
,	Week07Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 7 then cfr.StdQty end), 0)
,	Week08Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 8 then cfr.StdQty end), 0)
,	Week09Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 9 then cfr.StdQty end), 0)

,	Week10Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 10 then cfr.StdQty end), 0)
,	Week11Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 11 then cfr.StdQty end), 0)
,	Week12Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 12 then cfr.StdQty end), 0)
,	Week13Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 13 then cfr.StdQty end), 0)
,	Week14Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 14 then cfr.StdQty end), 0)
,	Week15Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 15 then cfr.StdQty end), 0)
,	Week16Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 16 then cfr.StdQty end), 0)
,	Week17Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 17 then cfr.StdQty end), 0)
,	Week18Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 18 then cfr.StdQty end), 0)
,	Week19Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 19 then cfr.StdQty end), 0)

,	Week20Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 20 then cfr.StdQty end), 0)
,	Week21Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 21 then cfr.StdQty end), 0)
,	Week22Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 22 then cfr.StdQty end), 0)
,	Week23Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 23 then cfr.StdQty end), 0)
,	Week24Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 24 then cfr.StdQty end), 0)
,	Week25Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 25 then cfr.StdQty end), 0)
,	Week26Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 26 then cfr.StdQty end), 0)
,	Week27Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 27 then cfr.StdQty end), 0)
,	Week28Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 28 then cfr.StdQty end), 0)
,	Week29Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 29 then cfr.StdQty end), 0)

,	Week30Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 30 then cfr.StdQty end), 0)
,	Week31Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 31 then cfr.StdQty end), 0)
,	Week32Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 32 then cfr.StdQty end), 0)
,	Week33Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 33 then cfr.StdQty end), 0)
,	Week34Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 34 then cfr.StdQty end), 0)
,	Week35Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 35 then cfr.StdQty end), 0)
,	Week36Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 36 then cfr.StdQty end), 0)
,	Week37Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 37 then cfr.StdQty end), 0)
,	Week38Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 38 then cfr.StdQty end), 0)
,	Week39Qty = -coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 39 then cfr.StdQty end), 0)

,	Week00Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 0 then cfr.Change end), 0)
,	Week01Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 1 then cfr.Change end), 0)
,	Week02Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 2 then cfr.Change end), 0)
,	Week03Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 3 then cfr.Change end), 0)
,	Week04Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 4 then cfr.Change end), 0)
,	Week05Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 5 then cfr.Change end), 0)
,	Week06Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 6 then cfr.Change end), 0)
,	Week07Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 7 then cfr.Change end), 0)
,	Week08Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 8 then cfr.Change end), 0)
,	Week09Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 9 then cfr.Change end), 0)

,	Week10Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 10 then cfr.Change end), 0)
,	Week11Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 11 then cfr.Change end), 0)
,	Week12Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 12 then cfr.Change end), 0)
,	Week13Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 13 then cfr.Change end), 0)
,	Week14Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 14 then cfr.Change end), 0)
,	Week15Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 15 then cfr.Change end), 0)
,	Week16Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 16 then cfr.Change end), 0)
,	Week17Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 17 then cfr.Change end), 0)
,	Week18Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 18 then cfr.Change end), 0)
,	Week19Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 19 then cfr.Change end), 0)

,	Week20Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 20 then cfr.Change end), 0)
,	Week21Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 21 then cfr.Change end), 0)
,	Week22Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 22 then cfr.Change end), 0)
,	Week23Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 23 then cfr.Change end), 0)
,	Week24Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 24 then cfr.Change end), 0)
,	Week25Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 25 then cfr.Change end), 0)
,	Week26Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 26 then cfr.Change end), 0)
,	Week27Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 27 then cfr.Change end), 0)
,	Week28Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 28 then cfr.Change end), 0)
,	Week29Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 29 then cfr.Change end), 0)

,	Week30Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 30 then cfr.Change end), 0)
,	Week31Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 31 then cfr.Change end), 0)
,	Week32Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 32 then cfr.Change end), 0)
,	Week33Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 33 then cfr.Change end), 0)
,	Week34Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 34 then cfr.Change end), 0)
,	Week35Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 35 then cfr.Change end), 0)
,	Week36Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 36 then cfr.Change end), 0)
,	Week37Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 37 then cfr.Change end), 0)
,	Week38Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 38 then cfr.Change end), 0)
,	Week39Delta = coalesce(max(case when cfr.WeekNo - cfr.GeneratedWeekNo = 39 then cfr.Change end), 0)
from
	(	select
			mfr.ReleasePlanID
		,	mfr.GeneratedWeekNo
		,	mfr.BasePart
		,	ProductLine = max(mfr.ProductLine)
		,	StandardPack = max(mfr.StandardPack)
		,	Price = max(mfr.Price)
		,	StdDev = coalesce(stdev(nullif(mfr.Change, 0)), 0) * coalesce(avg(nullif(mfr.StdQty, 0)), 0) * max(mfr.Price)
		,	OnHandQty = max(mfr.OnHandQty)
		from
			@ManufacturingFluctuationRaw mfr
		group by
			mfr.ReleasePlanID
		,	mfr.GeneratedWeekNo
		,	mfr.BasePart
	) mfr
	left join @CustomerFluctuationRaw cfr
		on cfr.BasePart = mfr.BasePart
group by
	mfr.ReleasePlanID
,	mfr.GeneratedWeekNo
,	mfr.BasePart

union all

select
	mfr.ReleasePlanID
,	mfr.GeneratedWeekNo
,	mfr.BasePart
,	mfr.ProductLine
,	mfr.StandardPack
,	mfr.Price
,	LineType = '3. PROJECTED INV'

,	StdDev = mfr.StdDev
,	OnHandQty = mfr.OnHandQty

,	Week00Qty = mfr.OnHandQty + mfr.Week00Qty + cfr.Week00Qty + iti.Week00Qty
,	Week01Qty = mfr.OnHandQty + mfr.Week01Qty + cfr.Week01Qty + iti.Week01Qty
,	Week02Qty = mfr.OnHandQty + mfr.Week02Qty + cfr.Week02Qty + iti.Week02Qty
,	Week03Qty = mfr.OnHandQty + mfr.Week03Qty + cfr.Week03Qty + iti.Week03Qty
,	Week04Qty = mfr.OnHandQty + mfr.Week04Qty + cfr.Week04Qty + iti.Week04Qty
,	Week05Qty = mfr.OnHandQty + mfr.Week05Qty + cfr.Week05Qty + iti.Week05Qty
,	Week06Qty = mfr.OnHandQty + mfr.Week06Qty + cfr.Week06Qty + iti.Week06Qty
,	Week07Qty = mfr.OnHandQty + mfr.Week07Qty + cfr.Week07Qty + iti.Week07Qty
,	Week08Qty = mfr.OnHandQty + mfr.Week08Qty + cfr.Week08Qty + iti.Week08Qty
,	Week09Qty = mfr.OnHandQty + mfr.Week09Qty + cfr.Week09Qty + iti.Week09Qty
				
,	Week10Qty = mfr.OnHandQty + mfr.Week10Qty + cfr.Week10Qty + iti.Week10Qty
,	Week11Qty = mfr.OnHandQty + mfr.Week11Qty + cfr.Week11Qty + iti.Week11Qty
,	Week12Qty = mfr.OnHandQty + mfr.Week12Qty + cfr.Week12Qty + iti.Week12Qty
,	Week13Qty = mfr.OnHandQty + mfr.Week13Qty + cfr.Week13Qty + iti.Week13Qty
,	Week14Qty = mfr.OnHandQty + mfr.Week14Qty + cfr.Week14Qty + iti.Week14Qty
,	Week15Qty = mfr.OnHandQty + mfr.Week15Qty + cfr.Week15Qty + iti.Week15Qty
,	Week16Qty = mfr.OnHandQty + mfr.Week16Qty + cfr.Week16Qty + iti.Week16Qty
,	Week17Qty = mfr.OnHandQty + mfr.Week17Qty + cfr.Week17Qty + iti.Week17Qty
,	Week18Qty = mfr.OnHandQty + mfr.Week18Qty + cfr.Week18Qty + iti.Week18Qty
,	Week19Qty = mfr.OnHandQty + mfr.Week19Qty + cfr.Week19Qty + iti.Week19Qty
				
,	Week20Qty = mfr.OnHandQty + mfr.Week20Qty + cfr.Week20Qty + iti.Week20Qty
,	Week21Qty = mfr.OnHandQty + mfr.Week21Qty + cfr.Week21Qty + iti.Week21Qty
,	Week22Qty = mfr.OnHandQty + mfr.Week22Qty + cfr.Week22Qty + iti.Week22Qty
,	Week23Qty = mfr.OnHandQty + mfr.Week23Qty + cfr.Week23Qty + iti.Week23Qty
,	Week24Qty = mfr.OnHandQty + mfr.Week24Qty + cfr.Week24Qty + iti.Week24Qty
,	Week25Qty = mfr.OnHandQty + mfr.Week25Qty + cfr.Week25Qty + iti.Week25Qty
,	Week26Qty = mfr.OnHandQty + mfr.Week26Qty + cfr.Week26Qty + iti.Week26Qty
,	Week27Qty = mfr.OnHandQty + mfr.Week27Qty + cfr.Week27Qty + iti.Week27Qty
,	Week28Qty = mfr.OnHandQty + mfr.Week28Qty + cfr.Week28Qty + iti.Week28Qty
,	Week29Qty = mfr.OnHandQty + mfr.Week29Qty + cfr.Week29Qty + iti.Week29Qty
				
,	Week30Qty = mfr.OnHandQty + mfr.Week30Qty + cfr.Week30Qty + iti.Week30Qty
,	Week31Qty = mfr.OnHandQty + mfr.Week31Qty + cfr.Week31Qty + iti.Week31Qty
,	Week32Qty = mfr.OnHandQty + mfr.Week32Qty + cfr.Week32Qty + iti.Week32Qty
,	Week33Qty = mfr.OnHandQty + mfr.Week33Qty + cfr.Week33Qty + iti.Week33Qty
,	Week34Qty = mfr.OnHandQty + mfr.Week34Qty + cfr.Week34Qty + iti.Week34Qty
,	Week35Qty = mfr.OnHandQty + mfr.Week35Qty + cfr.Week35Qty + iti.Week35Qty
,	Week36Qty = mfr.OnHandQty + mfr.Week36Qty + cfr.Week36Qty + iti.Week36Qty
,	Week37Qty = mfr.OnHandQty + mfr.Week37Qty + cfr.Week37Qty + iti.Week37Qty
,	Week38Qty = mfr.OnHandQty + mfr.Week38Qty + cfr.Week38Qty + iti.Week38Qty
,	Week39Qty = mfr.OnHandQty + mfr.Week39Qty + cfr.Week39Qty + iti.Week39Qty

,	Week00Delta = 0
,	Week01Delta = 0
,	Week02Delta = 0
,	Week03Delta = 0
,	Week04Delta = 0
,	Week05Delta = 0
,	Week06Delta = 0
,	Week07Delta = 0
,	Week08Delta = 0
,	Week09Delta = 0

,	Week10Delta = 0
,	Week11Delta = 0
,	Week12Delta = 0
,	Week13Delta = 0
,	Week14Delta = 0
,	Week15Delta = 0
,	Week16Delta = 0
,	Week17Delta = 0
,	Week18Delta = 0
,	Week19Delta = 0

,	Week20Delta = 0
,	Week21Delta = 0
,	Week22Delta = 0
,	Week23Delta = 0
,	Week24Delta = 0
,	Week25Delta = 0
,	Week26Delta = 0
,	Week27Delta = 0
,	Week28Delta = 0
,	Week29Delta = 0

,	Week30Delta = 0
,	Week31Delta = 0
,	Week32Delta = 0
,	Week33Delta = 0
,	Week34Delta = 0
,	Week35Delta = 0
,	Week36Delta = 0
,	Week37Delta = 0
,	Week38Delta = 0
,	Week39Delta = 0
from
	(	select
			ReleasePlanID = max(mfr.ReleasePlanID)
		,	GeneratedWeekNo = max(mfr.GeneratedWeekNo)
		,	mfr.BasePart
		,	ProductLine = max(mfr.ProductLine)
		,	StandardPack = max(mfr.StandardPack)
		,	Price = max(mfr.Price)

		,	StdDev = coalesce(stdev(nullif(mfr.Change, 0)), 0) * coalesce(avg(nullif(mfr.StdQty, 0)), 0) * max(mfr.Price)
		,	OnHandQty = max(mfr.OnHandQty)

		,	Week00Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 0 then mfr.StdQty end), 0)
		,	Week01Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 1 then mfr.StdQty end), 0)
		,	Week02Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 2 then mfr.StdQty end), 0)
		,	Week03Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 3 then mfr.StdQty end), 0)
		,	Week04Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 4 then mfr.StdQty end), 0)
		,	Week05Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 5 then mfr.StdQty end), 0)
		,	Week06Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 6 then mfr.StdQty end), 0)
		,	Week07Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 7 then mfr.StdQty end), 0)
		,	Week08Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 8 then mfr.StdQty end), 0)
		,	Week09Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 9 then mfr.StdQty end), 0)

		,	Week10Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 10 then mfr.StdQty end), 0)
		,	Week11Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 11 then mfr.StdQty end), 0)
		,	Week12Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 12 then mfr.StdQty end), 0)
		,	Week13Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 13 then mfr.StdQty end), 0)
		,	Week14Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 14 then mfr.StdQty end), 0)
		,	Week15Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 15 then mfr.StdQty end), 0)
		,	Week16Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 16 then mfr.StdQty end), 0)
		,	Week17Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 17 then mfr.StdQty end), 0)
		,	Week18Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 18 then mfr.StdQty end), 0)
		,	Week19Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 19 then mfr.StdQty end), 0)

		,	Week20Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 20 then mfr.StdQty end), 0)
		,	Week21Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 21 then mfr.StdQty end), 0)
		,	Week22Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 22 then mfr.StdQty end), 0)
		,	Week23Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 23 then mfr.StdQty end), 0)
		,	Week24Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 24 then mfr.StdQty end), 0)
		,	Week25Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 25 then mfr.StdQty end), 0)
		,	Week26Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 26 then mfr.StdQty end), 0)
		,	Week27Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 27 then mfr.StdQty end), 0)
		,	Week28Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 28 then mfr.StdQty end), 0)
		,	Week29Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 29 then mfr.StdQty end), 0)

		,	Week30Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 30 then mfr.StdQty end), 0)
		,	Week31Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 31 then mfr.StdQty end), 0)
		,	Week32Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 32 then mfr.StdQty end), 0)
		,	Week33Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 33 then mfr.StdQty end), 0)
		,	Week34Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 34 then mfr.StdQty end), 0)
		,	Week35Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 35 then mfr.StdQty end), 0)
		,	Week36Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 36 then mfr.StdQty end), 0)
		,	Week37Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 37 then mfr.StdQty end), 0)
		,	Week38Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 38 then mfr.StdQty end), 0)
		,	Week39Qty = coalesce(sum(case when mfr.WeekNo - mfr.GeneratedWeekNo <= 39 then mfr.StdQty end), 0)
		from
			@ManufacturingFluctuationRaw mfr
		group by
			mfr.BasePart
	) mfr
	left join
		(	select
				mfr.BasePart
			,	Week00Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 0 then cfr.StdQty end), 0)
			,	Week01Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 1 then cfr.StdQty end), 0)
			,	Week02Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 2 then cfr.StdQty end), 0)
			,	Week03Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 3 then cfr.StdQty end), 0)
			,	Week04Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 4 then cfr.StdQty end), 0)
			,	Week05Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 5 then cfr.StdQty end), 0)
			,	Week06Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 6 then cfr.StdQty end), 0)
			,	Week07Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 7 then cfr.StdQty end), 0)
			,	Week08Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 8 then cfr.StdQty end), 0)
			,	Week09Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 9 then cfr.StdQty end), 0)

			,	Week10Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 10 then cfr.StdQty end), 0)
			,	Week11Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 11 then cfr.StdQty end), 0)
			,	Week12Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 12 then cfr.StdQty end), 0)
			,	Week13Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 13 then cfr.StdQty end), 0)
			,	Week14Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 14 then cfr.StdQty end), 0)
			,	Week15Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 15 then cfr.StdQty end), 0)
			,	Week16Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 16 then cfr.StdQty end), 0)
			,	Week17Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 17 then cfr.StdQty end), 0)
			,	Week18Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 18 then cfr.StdQty end), 0)
			,	Week19Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 19 then cfr.StdQty end), 0)

			,	Week20Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 20 then cfr.StdQty end), 0)
			,	Week21Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 21 then cfr.StdQty end), 0)
			,	Week22Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 22 then cfr.StdQty end), 0)
			,	Week23Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 23 then cfr.StdQty end), 0)
			,	Week24Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 24 then cfr.StdQty end), 0)
			,	Week25Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 25 then cfr.StdQty end), 0)
			,	Week26Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 26 then cfr.StdQty end), 0)
			,	Week27Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 27 then cfr.StdQty end), 0)
			,	Week28Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 28 then cfr.StdQty end), 0)
			,	Week29Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 29 then cfr.StdQty end), 0)

			,	Week30Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 30 then cfr.StdQty end), 0)
			,	Week31Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 31 then cfr.StdQty end), 0)
			,	Week32Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 32 then cfr.StdQty end), 0)
			,	Week33Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 33 then cfr.StdQty end), 0)
			,	Week34Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 34 then cfr.StdQty end), 0)
			,	Week35Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 35 then cfr.StdQty end), 0)
			,	Week36Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 36 then cfr.StdQty end), 0)
			,	Week37Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 37 then cfr.StdQty end), 0)
			,	Week38Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 38 then cfr.StdQty end), 0)
			,	Week39Qty = -coalesce(sum(case when cfr.WeekNo - cfr.GeneratedWeekNo <= 39 then cfr.StdQty end), 0)
			from
				(	select
						mfr.ReleasePlanID
					,	mfr.GeneratedWeekNo
					,	mfr.BasePart
					,	ProductLine = max(mfr.ProductLine)
					,	StandardPack = max(mfr.StandardPack)
					,	Price = max(mfr.Price)
					,	StdDev = coalesce(stdev(nullif(mfr.Change, 0)), 0) * coalesce(avg(nullif(mfr.StdQty, 0)), 0) * max(mfr.Price)
					,	OnHandQty = max(mfr.OnHandQty)
					from
						@ManufacturingFluctuationRaw mfr
					group by
						mfr.ReleasePlanID
					,	mfr.GeneratedWeekNo
					,	mfr.BasePart
				) mfr
				left join @CustomerFluctuationRaw cfr
					on cfr.BasePart = mfr.BasePart
			group by
				mfr.BasePart
		) cfr
		on cfr.BasePart = mfr.BasePart
	left join
		(	select
				mfr.BasePart
			,	Week00Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 0 then iti.Quantity end), 0)
			,	Week01Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week02Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week03Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week04Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week05Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week06Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week07Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week08Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week09Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)

			,	Week10Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week11Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week12Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week13Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week14Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week15Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week16Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week17Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week18Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week19Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)

			,	Week20Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week21Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week22Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week23Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week24Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week25Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week26Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week27Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week28Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week29Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)

			,	Week30Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week31Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week32Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week33Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week34Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week35Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week36Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week37Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week38Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			,	Week39Qty = coalesce(sum(case when datediff(week, @ScheduleDT, iti.IntransitDT) <= 1 then iti.Quantity end), 0)
			from
				(	select
						mfr.ReleasePlanID
					,	mfr.GeneratedWeekNo
					,	mfr.BasePart
					,	ProductLine = max(mfr.ProductLine)
					,	StandardPack = max(mfr.StandardPack)
					,	Price = max(mfr.Price)
					,	StdDev = coalesce(stdev(nullif(mfr.Change, 0)), 0) * coalesce(avg(nullif(mfr.StdQty, 0)), 0) * max(mfr.Price)
					,	OnHandQty = max(mfr.OnHandQty)
					from
						@ManufacturingFluctuationRaw mfr
					group by
						mfr.ReleasePlanID
					,	mfr.GeneratedWeekNo
					,	mfr.BasePart
				) mfr
				left join @InTransitInventory iti
					on iti.BasePart = mfr.BasePart
			group by
				mfr.BasePart
		) iti
		on iti.BasePart = mfr.BasePart

union all

select
	mfr.ReleasePlanID
,	mfr.GeneratedWeekNo
,	mfr.BasePart
,	ProductLine = max(mfr.ProductLine)
,	StandardPack = max(mfr.StandardPack)
,	Price = max(mfr.Price)
,	LineType = '4. SHIP HIST'

,	StdDev = max(mfr.StdDev)
,	OnHandQty = max(mfr.OnHandQty)

,	Week00Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 00 then sh.ShipQty end), 0)
,	Week01Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 01 then sh.ShipQty end), 0)
,	Week02Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 02 then sh.ShipQty end), 0)
,	Week03Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 03 then sh.ShipQty end), 0)
,	Week04Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 04 then sh.ShipQty end), 0)
,	Week05Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 05 then sh.ShipQty end), 0)
,	Week06Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 06 then sh.ShipQty end), 0)
,	Week07Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 07 then sh.ShipQty end), 0)
,	Week08Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 08 then sh.ShipQty end), 0)
,	Week09Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 09 then sh.ShipQty end), 0)

,	Week10Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 10 then sh.ShipQty end), 0)
,	Week11Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 11 then sh.ShipQty end), 0)
,	Week12Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 12 then sh.ShipQty end), 0)
,	Week13Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 13 then sh.ShipQty end), 0)
,	Week14Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 14 then sh.ShipQty end), 0)
,	Week15Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 15 then sh.ShipQty end), 0)
,	Week16Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 16 then sh.ShipQty end), 0)
,	Week17Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 17 then sh.ShipQty end), 0)
,	Week18Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 18 then sh.ShipQty end), 0)
,	Week19Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 19 then sh.ShipQty end), 0)

,	Week20Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 20 then sh.ShipQty end), 0)
,	Week21Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 21 then sh.ShipQty end), 0)
,	Week22Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 22 then sh.ShipQty end), 0)
,	Week23Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 23 then sh.ShipQty end), 0)
,	Week24Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 24 then sh.ShipQty end), 0)
,	Week25Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 25 then sh.ShipQty end), 0)
,	Week26Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 26 then sh.ShipQty end), 0)
,	Week27Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 27 then sh.ShipQty end), 0)
,	Week28Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 28 then sh.ShipQty end), 0)
,	Week29Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 29 then sh.ShipQty end), 0)

,	Week30Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 30 then sh.ShipQty end), 0)
,	Week31Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 31 then sh.ShipQty end), 0)
,	Week32Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 32 then sh.ShipQty end), 0)
,	Week33Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 33 then sh.ShipQty end), 0)
,	Week34Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 34 then sh.ShipQty end), 0)
,	Week35Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 35 then sh.ShipQty end), 0)
,	Week36Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 36 then sh.ShipQty end), 0)
,	Week37Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 37 then sh.ShipQty end), 0)
,	Week38Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 38 then sh.ShipQty end), 0)
,	Week39Qty = coalesce(max(case when sh.WeekNo = @AnalysisGeneratedWeekNo + 39 then sh.ShipQty end), 0)

,	Week00Delta = 0
,	Week01Delta = 0
,	Week02Delta = 0
,	Week03Delta = 0
,	Week04Delta = 0
,	Week05Delta = 0
,	Week06Delta = 0
,	Week07Delta = 0
,	Week08Delta = 0
,	Week09Delta = 0

,	Week10Delta = 0
,	Week11Delta = 0
,	Week12Delta = 0
,	Week13Delta = 0
,	Week14Delta = 0
,	Week15Delta = 0
,	Week16Delta = 0
,	Week17Delta = 0
,	Week18Delta = 0
,	Week19Delta = 0

,	Week20Delta = 0
,	Week21Delta = 0
,	Week22Delta = 0
,	Week23Delta = 0
,	Week24Delta = 0
,	Week25Delta = 0
,	Week26Delta = 0
,	Week27Delta = 0
,	Week28Delta = 0
,	Week29Delta = 0

,	Week30Delta = 0
,	Week31Delta = 0
,	Week32Delta = 0
,	Week33Delta = 0
,	Week34Delta = 0
,	Week35Delta = 0
,	Week36Delta = 0
,	Week37Delta = 0
,	Week38Delta = 0
,	Week39Delta = 0
from
	(	select
			mfr.ReleasePlanID
		,	mfr.GeneratedWeekNo
		,	mfr.BasePart
		,	ProductLine = max(mfr.ProductLine)
		,	StandardPack = max(mfr.StandardPack)
		,	Price = max(mfr.Price)
		,	StdDev = coalesce(stdev(nullif(mfr.Change, 0)), 0) * coalesce(avg(nullif(mfr.StdQty, 0)), 0) * max(mfr.Price)
		,	OnHandQty = max(mfr.OnHandQty)
		from
			@ManufacturingFluctuationRaw mfr
		group by
			mfr.ReleasePlanID
		,	mfr.GeneratedWeekNo
		,	mfr.BasePart
	) mfr
	left join @ShipHistory sh
		on sh.BasePart = mfr.BasePart
group by
	mfr.ReleasePlanID
,	mfr.GeneratedWeekNo
,	mfr.BasePart

order by
	3, 7
--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@AnalysisGeneratedWeekNo int = 1000

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = TOPS.usp_Analysis_WeeklyManufacturingFluctuation
	@AnalysisGeneratedWeekNo = @AnalysisGeneratedWeekNo

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[eeisp_rpt_materials_projected_receipts_1]
as 
declare @PriorPOs table
(   PONumber int
,	Part varchar(25)
,	DueWeek datetime
,	Balance numeric(20, 6)
,	primary key (PONumber, Part, DueWeek)
)

declare @PriorReleasePlans table
(	ReleasePlanID int
,	primary key (ReleasePlanID)
)

declare
	@Datebk5wk datetime
,	@Datebk4wk datetime
,	@Datebk3wk datetime
,	@Datebk2wk datetime
,	@Datebk1wk datetime
,	@Datebk0wk datetime
,	@RPDatebk5wk datetime
,	@RPDatebk4wk datetime
,	@RPDatebk3wk datetime
,	@RPDatebk2wk datetime
,	@RPDatebk1wk datetime
,	@RPDatebk0wk datetime

select
	@Datebk5wk = dateadd(wk, -5, ft.fn_TruncDate('wk', getdate()))

select
	@Datebk4wk = dateadd(wk, -4, ft.fn_TruncDate('wk', getdate()))

select
	@Datebk3wk = dateadd(wk, -3, ft.fn_TruncDate('wk', getdate()))

select
	@Datebk2wk = dateadd(wk, -2, ft.fn_TruncDate('wk', getdate()))

select
	@Datebk1wk = dateadd(wk, -1, ft.fn_TruncDate('wk', getdate()))

select
	@Datebk0wk = dateadd(wk, 0, ft.fn_TruncDate('wk', getdate()))

select
	@RPDatebk5wk = min(GeneratedDT)
from
	FT.releasePlans
where
	GeneratedDT >= @Datebk5wk
	and GeneratedDT < @Datebk4wk
	and GeneratedWeekDay > 1

select
	@RPDatebk4wk = min(GeneratedDT)
from
	FT.releasePlans
where
	GeneratedDT >= @Datebk4wk
	and GeneratedDT < @Datebk3wk
	and GeneratedWeekDay > 1

select
	@RPDatebk3wk = min(GeneratedDT)
from
	FT.releasePlans
where
	GeneratedDT >= @Datebk3wk
	and GeneratedDT < @Datebk2wk
	and GeneratedWeekDay > 1

select
	@RPDatebk2wk = min(GeneratedDT)
from
	FT.releasePlans
where
	GeneratedDT >= @Datebk2wk
	and GeneratedDT < @Datebk1wk
	and GeneratedWeekDay > 1

select
	@RPDatebk1wk = min(GeneratedDT)
from
	FT.releasePlans
where
	GeneratedDT >= @Datebk1wk
	and GeneratedDT < @Datebk0wk
	and GeneratedWeekDay > 1


select
	@RPDatebk0wk = min(GeneratedDT)
from
	FT.releasePlans
where
	GeneratedDT >= @Datebk0wk
	and GeneratedWeekDay >= 1

insert
	@PriorReleasePlans
select
	ID
from
	FT.releasePlans
where
	GeneratedDT in
	(	select
			@RPDatebk5wk
		union
		select
			@RPDatebk4wk
		union
		select
			@RPDatebk3wk
		union
		select
			@RPDatebk2wk
		union
		select
			@RpDatebk1wk
		union
		select
			@RpDatebk0wk
	)

declare @PriorPOReleases table
(	ReleasePlanID int
,	VendorCode varchar(10)
,	PONumber int
,	Part varchar(25)
,	StdQty numeric(20,6)
,	DueDate datetime
,	Cost numeric(20,6)
,	Extended numeric(20,6)
)

insert
	@PriorPOReleases
select
	ReleasePlanID
,	po_header.vendor_code as VendorCode
,	PONumber as PONumber
,	FT.ReleasePlanRaw.Part as Part
,	sum(StdQty) as StdQty
,	ft.fn_TruncDate('wk', DueDT) as DueDate
,	max(material_cum) as Cost
,	sum(StdQty * isnull(material_cum, 0)) as Extended
from
	FT.ReleasePlanRaw
	join part_standard
		on FT.ReleasePlanRaw.Part = part_standard.part
	join FT.releasePlans
		on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
	join po_header
		on FT.ReleasePlanRaw.PONumber = po_header.po_number
where
	DueDT < dateadd(wk, 0, @Datebk0wk)
	and DueDT >= dateadd(wk, -2, @Datebk5wk)
	and ID in (select
				ReleasePlanID
			   from
				@PriorReleasePlans)
group by
	ReleasePlanID
,	po_header.vendor_code
,	PONumber
,	FT.ReleasePlanRaw.Part
,	ft.fn_TruncDate('wk', DueDT)
order by
	PONumber
,	ft.fn_TruncDate('wk', DueDT)
,	ReleasePlanID

declare	@POReleases table
(	VendorCode varchar(10)
,	PONumber int
,	Part varchar(25)
,	DueDate datetime
,	StdQty numeric(20,6)
,	Cost numeric(20,6)
,	Extended numeric(20,6)
)

insert
	@POReleases
select
	VendorCode
,	PONumber
,	Part
,	DueDate
,	max(StdQty) StdQty
,	max(cost) Cost
,	max(extended) Extended
from
	@PriorPOReleases
group by
	VendorCode
,	PONumber
,	Part
,	DueDate

declare @POsDue table
(	Vendor varchar(15)
,	PONumber int
,	part varchar(25)
,	DueDT datetime
,	Qty numeric(20, 6)
,	Cost numeric(20, 6)
,	Extended numeric(20, 6)
,	primary key (POnumber, Part, DueDT)
)

insert  @POsDue
(	Vendor
,	PONumber
,	part
,	DueDT
,	Qty
,	Cost
,	Extended 
)
select
	coalesce(vendor_code, vendorCode)
,	coalesce(po_number, PONumber)
,	coalesce(part_number, POReleases.Part)
,	coalesce(ft.fn_truncdate('wk', date_due), DueDate)
,	dbo.fn_GreaterOf(isnull(sum(balance), 0), isnull(sum(stdQty), 0))
,	coalesce(material, POReleases.Cost)
,	dbo.fn_GreaterOf(isnull(sum(balance * material_cum), 0), isnull(sum(Extended), 0))
from
	po_detail
	full join @POReleases POReleases
		on ft.fn_truncdate('wk', po_detail.date_due) = DueDate
		   and po_number = PONumber
		   and part_number = part
	join part_standard
		on po_detail.part_number = part_standard.part
where
	date_due >= dateadd(wk, 0, @Datebk0wk)
group by
	coalesce(vendor_code, vendorCode)
,	coalesce(po_number, PONumber)
,	coalesce(part_number, POReleases.Part)
,	coalesce(ft.fn_truncdate('wk', date_due), DueDate)
,	coalesce(material, POReleases.Cost)
having
	dbo.fn_GreaterOf(isnull(sum(balance), 0), isnull(sum(stdQty), 0)) > 0
union
select
	*
from
	@POReleases

declare @POsReceived table
(	Vendor varchar(15)
,	PONumber int
,	part varchar(25)
,	ReceivedDT datetime
,	Qty numeric(20, 6)
,	Cost numeric(20, 6)
,	Extended numeric(20, 6)
,	primary key (POnumber, Part, ReceivedDT)
)

insert
	@POsReceived
(	Vendor
,	PONumber
,	part
,	ReceivedDT
,	Qty
,	Cost
,	Extended 
)
select
	vendor
,	po_number
,	audit_trail.part
,	ft.fn_truncdate('wk', (case when date_stamp < @RPDatebk4wk then @RPDatebk4wk
								else date_stamp
						   end))
,	sum(quantity)
,	material
,	sum(quantity * material)
from
	audit_trail
	join part_standard
		on audit_trail.part = part_standard.part
where
	type = 'R'
	and date_stamp >= @RPDatebk4wk
group by
	vendor
,	po_number
,	audit_trail.part
,	ft.fn_truncdate('wk', (case when date_stamp < @RPDatebk4wk then @RPDatebk4wk
								else date_stamp
						   end))
,	material

declare @Buckets table
(	BucketDT datetime
,	primary key (BucketDT)
)

declare
	@Date1 datetime
,	@Date2 datetime

select
	@date1 = @RPDatebk4wk
select
	@date2 = dateadd(wk, 26, @date1)

insert
	@Buckets
select
	ft.fn_truncdate('wk', EntryDT)
from
	FT.fn_Calendar(@date1, @date2, 'wk', 1, 26)
where
	EntryDT >= @RPDatebk4wk
order by
	1

declare @POPartList table
(	PONumber int
,	Part varchar(25)
,	primary key (PONumber, Part)
)

insert
	@POPartList
(	PONumber
,	Part
)
select distinct
	PONumber
,	Part
from
	@POsDue
union
select distinct
	PONumber
,	Part
from
	@POsReceived

declare @POandReceipts table
(	PONumber int
,	Part varchar(25)
,	BucketDT datetime
,	Vendor varchar(10)
,	POQty numeric(20,6)
,	UnitCost numeric(20,6)
,	ExtendedPODue numeric(20,6)
,	ReceivedQty numeric(20,6)
,	ExtendedPOReceived numeric(20,6)
,	StdPack numeric(20,6)
)

insert
	@POandReceipts
select
	POPartList.PONumber
,	POPartList.Part
,	BucketDT
,	coalesce(POSDue.Vendor, POSReceived.Vendor) as Vendor
,	isnull(POSDue.Qty, 0) as POQty
,	coalesce(POSDue.cost, POSReceived.Cost) as UnitCost
,	isnull(POsDue.Extended, 0) as ExtendedPODue
,	isnull(POSReceived.Qty, 0) as ReceivedQty
,	isnull(POsReceived.Extended, 0) as ExtendedPOReceived
,	part_inventory.standard_pack as StdPack
from
	@POPartList POPartList
	join part_inventory
		on POPartList.Part = part_inventory.part
	cross join @Buckets Buckets
	left join @POsDue POsDue
		on Buckets.BucketDT = POSDue.DueDT
		   and POPArtList.Part = POSDue.Part
		   and POPartList.PONumber = POSDue.PONumber
	left join @POsReceived POsReceived
		on Buckets.BucketDT = POSReceived.ReceivedDT
		   and POPArtList.Part = POSReceived.Part
		   and POPartList.PONumber = POSReceived.PONumber
where
	POsDue.Qty > 0
	or POSReceived.Qty > 0
order by
	1
,	2
,	4

select
	*
,	(case when ReceivedQty <= POQty then 0
		  else ReceivedQty - POQty
	 end) as OverReceiptQty
,	(case when ReceivedQty <= POQty then 0
		  else ReceivedQty - POQty
	 end) * UnitCost as OverReceiptExtended
from
	@POandReceipts
GO

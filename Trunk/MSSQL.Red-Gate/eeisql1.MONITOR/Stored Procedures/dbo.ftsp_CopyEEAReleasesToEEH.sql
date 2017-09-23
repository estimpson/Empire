SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ftsp_CopyEEAReleasesToEEH]
as
declare
	@EEAReleases table
(	OrderNo int
,	EEAPart varchar(25)
,	EEHPart varchar(25)
,	EEACustomerPart varchar(35)
,	EEHCustomerPart varchar(35)
,	EEAShipToID varchar(20)
,	EEHShipToID varchar(20)
,	OrderUnit char(2)
,	QtyRelease numeric(20, 6)
,	StdQtyRelease numeric(20, 6)
,	RelPrior numeric(20, 6)
,	RelPost numeric(20, 6)
,	ReleaseDT datetime
,	RowID int not null IDENTITY(1, 1) primary key
,	unique
	(	OrderNo
	,	EEAPart
	,	EEAShipToID
	,	ReleaseDT
	)
)

insert
	@EEAReleases
(	OrderNo, EEAPart, EEHPart, EEACustomerPart, EEHCustomerPart, EEAShipToID, EEHShipToID,
	OrderUnit, QtyRelease, StdQtyRelease, ReleaseDT)
select
	OrderNo = AtoH.EEHOrderNo
,	EEAPart = AtoH.AlabamaPart
,	EEHPart = AtoH.HondurasPart
,	EEACustomerPart = AtoH.EEACustomerPart
,	EEHCustomerPart = AtoH.EEHCustomerPart
,	EEAShipToID = AtoH.EEAShipToID
,	EEHShipToID = AtoH.EEHShipToID
,	OrderUnit = (select max(shipping_unit) from order_header where blanket_part = AtoH.HondurasPart and customer = 'EEA')
,	QtyRelease = sum(od.quantity)
,	StdQtyRelease = sum(od.std_qty)
,	ReleaseDT = dbo.fn_WeekDate
	(	min(od.due_date - coalesce(bd.BackDays, 0))
		, 2
	)
from
	dbo.order_detail od
	join dbo.order_header oh on
		od.order_no = oh.order_no
	join
	(	select
			EEACustomerPart = oh.customer_part
		,	EEAShipToID = oh.destination
		,	AlabamaPart = oh.blanket_part
		,	HondurasPart = bom.part
		,	EEHOrderNo = max(oh2.order_no)
		,	EEHShipToID = max(oh2.destination)
		,	EEHCustomerPart = max(oh2.customer_part)
		from
			dbo.order_header oh
			join dbo.bill_of_material bom on
				oh.blanket_part = bom.parent_part
			join dbo.order_header oh2 on
				oh2.blanket_part = bom.part
				and oh2.customer = 'EEA' 
--			and
--				bom.part like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]-H%'
		--where
		--	oh.status = 'A' AND oh.order_type = 'B' AND oh2.order_type = 'B'
		group by
			oh.customer_part
		,	oh.destination
		,	oh.blanket_part
		,	bom.part
	) AtoH on
		oh.blanket_part = AtoH.AlabamaPart
		and oh.customer_part = AtoH.EEACustomerPart
		and oh.destination = AtoH.EEAShipToID
	cross apply
		(	select
				BackDays = sum(dbo.part_eecustom.backdays)
			from
				dbo.part_eecustom
			where
				part in (AtoH.AlabamaPart, AtoH.HondurasPart)
		) bd
where
	od.part_number in
	(	select
			parent_part
		from
			dbo.bill_of_material bom
--		where
--			part like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]-H%'
	)
group by
	AtoH.EEACustomerPart
,	AtoH.EEHCustomerPart
,	AtoH.EEAShipToID
,	AtoH.EEHShipToID
,	AtoH.AlabamaPart
,	AtoH.HondurasPart
,	AtoH.EEHOrderNo
,	datediff(week, getdate(), od.due_date - coalesce(bd.BackDays, 0))
order by
	2, 11, 1, 6

update
	er
set
	RelPrior = a.Accum - er.StdQtyRelease
,	RelPost = a.Accum
from
	@EEAReleases er
	cross apply
		(	select
				Accum = sum(StdQtyRelease)
			from
				@EEAReleases er2
			where
				er2.EEAPart = er.EEAPart
				and er2.RowID <= er.RowID
		) a

declare
	@Inventory table
(	PartCode varchar(25) primary key
,	QtyOnHand numeric(20,6)
)

insert
	@Inventory
(	PartCode, QtyOnHand
)
select
	Part = o.part
,	QtyOnHand = sum (o.std_quantity)
from
	dbo.object o
where
	location not in
		(	select
				code
			from
				dbo.location l
			where
				l.secured_location = 'Y'
		)
	and
	o.part in
		(	select
				er.EEAPart
			from
				@EEAReleases er
		)
group by
	o.part

declare	@EEHReleases table
(	OrderNo int,
	OrderPart varchar(25),
	CustomerPart varchar(35),
	ShipToID varchar(20),
	CustomerPO varchar(20),
	ModelYear varchar(4),
	ReleaseNo varchar(30),
	OrderUnit char(2),
	QtyRelease numeric(20,6),
	RelPost numeric(20,6),
	QtyCommitted numeric(20,6),
	ReleaseDT datetime,
	Line int,
	primary key
	(	OrderNo
	,	ReleaseDT))

insert
	@EEHReleases
(	OrderNo,
	OrderPart,
	CustomerPart,
	ShipToID,
	OrderUnit,
	QtyRelease,
	ReleaseDT)
select
	OrderNo = EEAReleases.OrderNo
,	OrderPart = max(EEAReleases.EEHPart)
,	CustomerPart = max(EEAReleases.EEHCustomerPart)
,	ShipToID = max(EEAReleases.EEHShipToID)
,	OrderUnit = max(EEAReleases.OrderUnit)
,	QtyRelease = sum
		(	coalesce
			(	case when Inventory.QtyOnHand > EEAReleases.RelPrior then EEAReleases.RelPost - Inventory.QtyOnHand
				end
			,	EEAReleases.QtyRelease
			)
		)
,	ReleaseDT
from
	@EEAReleases EEAReleases
	left join @Inventory Inventory
		on EEAReleases.EEAPart = Inventory.PartCode
where
	EEAReleases.RelPost > coalesce(Inventory.QtyOnHand, 0)
group by
	OrderNo
,	ReleaseDT

update
	@EEHReleases
set
	RelPost = (select sum (QtyRelease) from @EEHReleases where OrderNo = EEHReleases.OrderNo and ReleaseDT <= EEHReleases.ReleaseDT),
	Line = (select count(*) from @EEHReleases where OrderNo = EEHReleases.OrderNo and ReleaseDT <= EEHReleases.ReleaseDT)
from
	@EEHReleases EEHReleases

update
	@EEHReleases
set
	QtyCommitted = coalesce(
	case
		when ShipperQty > RelPost then QtyRelease
		when ShipperQty > RelPost - QtyRelease then ShipperQty - (RelPost - QtyRelease)
	end, 0)
from
	@EEHReleases EEHReleases
	left join
	(	select
			OrderNo = shipper_detail.order_no,
			ShipperPart = shipper_detail.part_original,
			ShipperQty = sum (qty_required)
		from
			shipper_detail
			join shipper on shipper_detail.shipper = shipper.id
		where
			shipper.type is null and
			shipper.status in ('O', 'A', 'S')
		group by
			shipper_detail.order_no,
			shipper_detail.part_original) ShipRequirements on EEHReleases.OrderNo = ShipRequirements.OrderNo and
		EEHReleases.OrderPart = ShipRequirements.ShipperPart

delete
	dbo.order_detail
from
	dbo.order_detail od
	join dbo.order_header oh on od.order_no = oh.order_no
where
	oh.customer = 'EEA'

insert
	order_detail
(	order_no, sequence, part_number, product_name, type, quantity,
	status, notes, unit, due_date, release_no, destination,
	customer_part, row_id, flag, ship_type, packline_qty, plant,
	week_no, std_qty, our_cum, the_cum, price, alternate_price,
	committed_qty, eeiqty )
select
	order_no = eehr.OrderNo,
	sequence = eehr.Line + coalesce((select max (sequence) from order_detail where order_no = eehr.OrderNo), 0),
	part_number = eehr.OrderPart,
	product_name = (select name from dbo.part where part = eehr.OrderPart),
	type = 'P',
	quantity = eehr.QtyRelease,
	status = '',
	notes = 'EEA to EEH orders',
	unit = (select unit from order_header where order_no = eehr.OrderNo),
	due_date = eehr.ReleaseDT,
	release_no = eehr.ReleaseNo,
	destination = eehr.ShipToID,
	customer_part = eehr.CustomerPart,
	row_id = eehr.Line + coalesce((select max (row_id) from order_detail where order_no = eehr.OrderNo), 0),
	flag = 1,
	ship_type = 'N',
	packline_qty = 0,
	plant = (select plant from order_header where order_no = eehr.OrderNo),
	week_no = datediff(dd, (select fiscal_year_begin from parameters), eehr.ReleaseDT) / 7 + 1,
	std_qty = eehr.QtyRelease,
	our_cum = eehr.RelPost - eehr.QtyRelease + coalesce((select our_cum from order_header where order_no = eehr.OrderNo), (select max(the_cum) from order_detail where order_no = eehr.OrderNo), 0),
	the_cum = eehr.RelPost + coalesce((select our_cum from order_header where order_no = eehr.OrderNo), (select max(the_cum) from order_detail where order_no = eehr.OrderNo), 0),
	price = (select price from order_header where order_no = eehr.OrderNo),
	alternate_price = (select alternate_price from order_header where order_no = eehr.OrderNo),
	committed_qty = eehr.QtyCommitted,
	eeiqty = 0
from
	@EEHReleases eehr
GO

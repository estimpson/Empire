SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[ftsp_CopyEEAReleasesToEEH (Andre)]
as
declare	@EEAReleases table
(	OrderNo int,
	EEAPart varchar(25),
	EEHPart varchar(25),
	EEACustomerPart varchar(35),
	EEHCustomerPart varchar(35),
	EEAShipToID varchar(20),
	EEHShipToID varchar(20),
	OrderUnit char(2),
	QtyRelease numeric(20,6),
	StdQtyRelease numeric(20,6),
	RelPrior numeric(20,6),
	RelPost numeric(20,6),
	ReleaseDT datetime,
	primary key
	(	OrderNo
	,	ReleaseDT))

insert
	@EEAReleases
(	OrderNo, EEHPart, EEHCustomerPart, EEHShipToID,
	OrderUnit, QtyRelease, StdQtyRelease, ReleaseDT)
select
	OrderNo = AtoH.EEHOrderNo
,	EEHPart = AtoH.HondurasPart
,	EEHCustomerPart = max(AtoH.EEHCustomerPart)
,	EEHShipToID = AtoH.EEHShipToID
,	OrderUnit = (select max(shipping_unit) from order_header where blanket_part = AtoH.HondurasPart and customer = 'EEA')
,	QtyRelease = sum(od.quantity)
,	StdQtyRelease = sum(od.std_qty)
,	ReleaseDT =  ft.fn_TruncDate_monday('wk', od.due_date)
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
				and
					oh2.customer = 'EEA' 
			and
				bom.part like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]-H%'
		where
			oh.status = 'A' AND oh.order_type = 'B' AND oh2.order_type = 'B' and oh2.status ='A'
		group by
			oh.customer_part
		,	oh.destination
		,	oh.blanket_part
		,	bom.part
	) AtoH on
		oh.customer_part = AtoH.EEACustomerPart
	and
		oh.destination = AtoH.EEAShipToID
where
	part_number in
	(	select
			parent_part
		from
			dbo.bill_of_material bom
		where
			part like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]-H%'
	)
group by

	--AtoH.EEHCustomerPart
	AtoH.EEHShipToID
,	AtoH.HondurasPart
,	AtoH.EEHOrderNo
,	 ft.fn_TruncDate_monday('wk', od.due_date)
--having AtoH.EEHOrderNo!= 13396


update
	@EEAReleases
set
	RelPrior = coalesce (
	(	select
			sum (StdQtyRelease)
		from
			@EEAReleases
		where
			EEAPart = EEAReleases.EEAPart and
			ReleaseDT < EEAReleases.ReleaseDT), 0)
from
	@EEAReleases EEAReleases

update
	@EEAReleases
set
	RelPost = RelPrior + StdQtyRelease
from
	@EEAReleases EEAReleases

DECLARE	@Inventory TABLE
(	CustomerPart VARCHAR(35),
	ShipToID VARCHAR(20),
	QtyOnHand NUMERIC(20,6)
,	PRIMARY KEY
	(	CustomerPart
	,	ShipToID))

INSERT
	@Inventory
(	CustomerPart, ShipToID, QtyOnHand)
SELECT
	CStoP.CustomerPart
,	CStoP.ShipTo
,	QtyOnHand = SUM (o.std_quantity)
FROM
	dbo.object o
	JOIN
	(	SELECT
			CustomerPart = customer_part
		,	ShipTo = destination
		,	Part = blanket_part
		FROM
			dbo.order_header oh
		GROUP BY
			customer_part
		,	destination
		,	blanket_part
	) CStoP ON o.part = CStoP.Part
WHERE
	location NOT IN
	(	SELECT
			code
		FROM
			dbo.location l
		WHERE
			l.secured_location = 'Y')
AND
	o.part IN
	(	SELECT
			parent_part
		FROM
			dbo.bill_of_material bom
		WHERE
			part LIKE '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]-H%')
GROUP BY
	CStoP.CustomerPart
,	CStoP.ShipTo

DECLARE	@EEHReleases TABLE
(	OrderNo INT,
	OrderPart VARCHAR(25),
	CustomerPart VARCHAR(35),
	ShipToID VARCHAR(20),
	CustomerPO VARCHAR(20),
	ModelYear VARCHAR(4),
	ReleaseNo VARCHAR(30),
	OrderUnit CHAR(2),
	QtyRelease NUMERIC(20,6),
	RelPost NUMERIC(20,6),
	QtyCommitted NUMERIC(20,6),
	ReleaseDT DATETIME,
	Line INT,
	PRIMARY KEY
	(	OrderNo
	,	ReleaseDT))

INSERT
	@EEHReleases
(	OrderNo,
	OrderPart,
	CustomerPart,
	ShipToID,
	OrderUnit,
	QtyRelease,
	ReleaseDT)
SELECT
	OrderNo = EEAReleases.OrderNo,
	OrderPart = EEAReleases.EEHPart,
	CustomerPart = EEAReleases.EEHCustomerPart,
	ShipToID = EEAReleases.EEHShipToID,
	OrderUnit = EEAReleases.OrderUnit,
	QtyRelease = COALESCE(
	CASE
		WHEN Inventory.QtyOnHand > EEAReleases.RelPrior THEN EEAReleases.RelPost - Inventory.QtyOnHand
	END, EEAReleases.QtyRelease),
	ReleaseDT
FROM
	@EEAReleases EEAReleases
	LEFT JOIN @Inventory Inventory ON EEAReleases.EEACustomerPart = Inventory.CustomerPart AND
		EEAReleases.EEAShipToID = Inventory.ShipToID
WHERE
	EEAReleases.RelPost > COALESCE(Inventory.QtyOnHand, 0)

UPDATE
	@EEHReleases
SET
	RelPost = (SELECT SUM (QtyRelease) FROM @EEHReleases WHERE OrderNo = EEHReleases.OrderNo AND ReleaseDT <= EEHReleases.ReleaseDT),
	Line = (SELECT COUNT(1) FROM @EEHReleases WHERE OrderNo = EEHReleases.OrderNo AND ReleaseDT <= EEHReleases.ReleaseDT)
FROM
	@EEHReleases EEHReleases

UPDATE
	@EEHReleases
SET
	QtyCommitted = COALESCE(
	CASE
		WHEN ShipperQty > RelPost THEN QtyRelease
		WHEN ShipperQty > RelPost - QtyRelease THEN ShipperQty - (RelPost - QtyRelease)
	END, 0)
FROM
	@EEHReleases EEHReleases
	LEFT JOIN
	(	SELECT
			OrderNo = shipper_detail.order_no,
			ShipperPart = shipper_detail.part_original,
			ShipperQty = SUM (qty_required)		
		FROM
			shipper_detail
			JOIN shipper ON shipper_detail.shipper = shipper.id
		WHERE
			shipper.type IS NULL AND
			shipper.status IN ('O', 'A', 'S')
		GROUP BY
			shipper_detail.order_no,
			shipper_detail.part_original) ShipRequirements ON EEHReleases.OrderNo = ShipRequirements.OrderNo AND
		EEHReleases.OrderPart = ShipRequirements.ShipperPart

DELETE
	dbo.order_detail
FROM
	dbo.order_detail od
	JOIN dbo.order_header oh ON od.order_no = oh.order_no
WHERE
	oh.customer = 'EEA'

INSERT
	order_detail
(	order_no, sequence, part_number, product_name, type, quantity,
	status, notes, unit, due_date, release_no, destination,
	customer_part, row_id, flag, ship_type, packline_qty, plant,
	week_no, std_qty, our_cum, the_cum, price, alternate_price,
	committed_qty, eeiqty )
SELECT
	order_no = eehr.OrderNo,
	sequence = eehr.Line + COALESCE((SELECT MAX (sequence) FROM order_detail WHERE order_no = eehr.OrderNo), 0),
	part_number = eehr.OrderPart,
	product_name = (SELECT name FROM dbo.part WHERE part = eehr.OrderPart),
	type = 'P',
	quantity = eehr.QtyRelease,
	status = '',
	notes = 'EEA to EEH Orders' + '-' + CONVERT(VARCHAR(20), GETDATE(), 112),
	unit = (SELECT unit FROM order_header WHERE order_no = eehr.OrderNo),
	due_date = eehr.ReleaseDT,
	release_no = eehr.ReleaseNo,
	destination = eehr.ShipToID,
	customer_part = eehr.CustomerPart,
	row_id = eehr.Line + COALESCE((SELECT MAX (row_id) FROM order_detail WHERE order_no = eehr.OrderNo), 0),
	flag = 1,
	ship_type = 'N',
	packline_qty = 0,
	plant = (SELECT plant FROM order_header WHERE order_no = eehr.OrderNo),
	week_no = DATEDIFF(dd, (SELECT fiscal_year_begin FROM parameters), eehr.ReleaseDT) / 7 + 1,
	std_qty = eehr.QtyRelease,
	our_cum = eehr.RelPost - eehr.QtyRelease + COALESCE((SELECT our_cum FROM order_header WHERE order_no = eehr.OrderNo), (SELECT MAX(the_cum) FROM order_detail WHERE order_no = eehr.OrderNo), 0),
	the_cum = eehr.RelPost + COALESCE((SELECT our_cum FROM order_header WHERE order_no = eehr.OrderNo), (SELECT MAX(the_cum) FROM order_detail WHERE order_no = eehr.OrderNo), 0),
	price = (SELECT price FROM order_header WHERE order_no = eehr.OrderNo),
	alternate_price = (SELECT alternate_price FROM order_header WHERE order_no = eehr.OrderNo),
	committed_qty = eehr.QtyCommitted,
	eeiqty = 0
FROM
	@EEHReleases eehr











GO

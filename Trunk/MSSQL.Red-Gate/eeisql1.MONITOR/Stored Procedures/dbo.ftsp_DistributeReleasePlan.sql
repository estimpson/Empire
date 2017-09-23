SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[ftsp_DistributeReleasePlan]
as
/*
Assertions:
1) EDI must contain "Net" quantities because if we are shipping against other orders, the accums will get out of "whack."
2) Customer must only send 830's, otherwise we should be focussing on splitting 862's.
3) Release dates are shipping dates.
4) Exactly one part will be marked as the CurrentRevLevel.
5) Only one blanket order will exist for any revision.
*/
--begin transaction ProcessReleasePlan

--delete	log
--where	spid = @@spid

/*
insert	log
(	spid,
	id,
	message )
select	@@spid,
	(	select	isnull (max (id), 0) + 1
		from	log
		where	spid = @@spid),
	'Log purged successfully.'
*/
--execute ftsp_LogComment
--	@Comment = 'Log purged successfully.'


--execute ftsp_LogBegin --'Start processing ' + convert ( varchar ( 20 ), getdate ( ) ) + '.'
--	@StartDT = GetDate()

--execute ftsp_LogComment
--	@Comment = 'Searching for blanket order for customer part :  (' + @customerpart + ', destination :' + @shipto + ', customer po :' + @customerpo + ' & model year :'+ @modelyear+'.  Processing release #  (' + @releaseno+') due ' + convert ( varchar(20), @releasedt, 113) + '.'

	 
SELECT	*
INTO	#m_in_release_Plan
FROM	m_in_release_plan	 

declare	@RawReleases table
(	OrderNo int,
	OrderType char(1),
	BlanketPart varchar(25),
	CustomerPart varchar(35),
	ShipToID varchar(20),
	CustomerPO varchar(20),
	ModelYear varchar(4),
	ReleaseNo varchar(30),
	OrderUnit char(2),
	QtyRelease numeric(20,6),
	StdQtyRelease numeric(20,6),
	RelPrior numeric(20,6),
	RelPost numeric(20,6),
	ReleaseDT datetime)

update
	dbo.order_header
set
	customer_part = new_customer_part
,	new_customer_part = null
from
	dbo.m_in_release_plan mirp
	left join dbo.edi_setups es on mirp.shipto_id = es.destination
	join dbo.order_header oh on
		coalesce(oh.status, 'O') = 'A' and
		mirp.shipto_id = oh.destination and
		mirp.customer_part = oh.new_customer_part and
		(	coalesce (es.check_model_year, 'N') != 'Y' or
			mirp.model_year = oh.model_year) and
		(	coalesce (es.check_po, 'N') != 'Y' or
			mirp.customer_po = oh.customer_po)

insert
	@RawReleases
(	OrderNo, OrderType, BlanketPart, CustomerPart, ShipToID, CustomerPO, ModelYear,
	ReleaseNo, OrderUnit, QtyRelease, StdQtyRelease, ReleaseDT)
select
	OrderNo = oh.order_no,
	OrderType = isNull(mirp.release_dt_qualifier,''),
	BlanketPart = oh.blanket_part,
	CustomerPart = mirp.customer_part,
	ShipToID = mirp.shipto_id,
	CustomerPO = mirp.customer_po,
	ModelYear = mirp.model_year,
	ReleaseNo = mirp.release_no,
	OrderUnit = oh.shipping_unit,
	QtyRelease = mirp.quantity,
	StdQtyRelease = mirp.quantity * coalesce(
	(	select
			uc.conversion
		from
			dbo.part_unit_conversion puc
			join dbo.part_inventory pi on pi.part = puc.part
			join dbo.unit_conversion uc on puc.code = uc.code and
				uc.unit1 = oh.shipping_unit and
				uc.unit2 = pi.standard_unit
		where
			puc.part = oh.blanket_part), 1),
	ReleaseDT = mirp.release_dt
from
	dbo.m_in_release_plan mirp
	left join dbo.edi_setups es on mirp.shipto_id = es.destination
	join dbo.order_header oh on
		coalesce(oh.status, 'O') = 'A' and
		mirp.shipto_id = oh.destination and
		mirp.customer_part = oh.customer_part and
		(	coalesce (es.check_model_year, 'N') != 'Y' or
			mirp.model_year = oh.model_year) and
		(	coalesce (es.check_po, 'N') != 'Y' or
			mirp.customer_po = oh.customer_po)
/*where
	not exists
	(	select	1
		from	(	select
						RANQtyShipped = SUM(Qty),
						RanNumber
					from
						dbo.NALRanNumbersShipped nrns
					group by
						RanNumber) RANSShipped
		where
			RANSShipped.RANQtyShipped >= mirp.quantity and
			RANSShipped.RanNumber = mirp.release_no)*/
order by
	ReleaseDT,
	CustomerPart,
	OrderNo
	
/*update
	@RawReleases
set
	QtyRelease = QtyRelease-RANQtyShipped,
	StdQtyRelease = QtyRelease-RANQtyShipped
from
	@RawReleases RawReleases
	join
	(	select
			RANQtyShipped = SUM(Qty), 
			RanNumber 
		from
			dbo.NALRanNumbersShipped
		group by
			RanNumber) RANSShipped on RawReleases.ReleaseNo = RANSShipped.RanNumber*/

update
	@RawReleases
set
	RelPrior = coalesce (
	(	select
			sum (StdQtyRelease)
		from
			@RawReleases
		where
			BlanketPart = RawReleases.BlanketPart and
			ReleaseDT < RawReleases.ReleaseDT), 0)
from
	@RawReleases RawReleases

update
	@RawReleases
set
	RelPost = RelPrior + StdQtyRelease
from
	@RawReleases RawReleases

declare	@Inventory table
(	ID int IDENTITY,
	OrderNo int,
	InventoryPart varchar(25),
	CurrentRev char(1),
	CustomerPart varchar(35),
	ShipToID varchar(20),
	CustomerPO varchar(20),
	ModelYear varchar(4),
	QtyOnHand numeric(20,6),
	OhPrior numeric(20,6),
	OhPost numeric(20,6))

insert
	@Inventory
(	OrderNo, InventoryPart, CustomerPart, ShipToID, CustomerPO, ModelYear, QtyOnHand)
select
	OrderNo = order_header.order_no,
	InventoryPart = min(order_header.blanket_part),
	CustomerPart = min(m_in_release_plan.customer_part),
	ShipToID = min(m_in_release_plan.shipto_id),
	CustomerPO = min(m_in_release_plan.customer_po),
	ModelYear = min(m_in_release_plan.model_year),
	QtyOnHand = case when coalesce (min(order_header.status), 'O') != 'A' then coalesce(min(Inventory.QtyOnHand), 0) + coalesce(min(EEAtoEEHInventory.QtyOnHand), 0) else 900000000 end
from
	dbo.m_in_release_plan
	left join dbo.edi_setups on dbo.m_in_release_plan.shipto_id = dbo.edi_setups.destination
	join order_header on dbo.m_in_release_plan.shipto_id = dbo.order_header.destination and
		dbo.m_in_release_plan.customer_part = dbo.order_header.customer_part and
		(	coalesce (check_model_year, 'N') != 'Y' or
			dbo.m_in_release_plan.model_year = dbo.order_header.model_year) and
		(	coalesce (check_po, 'N') != 'Y' or
			dbo.m_in_release_plan.customer_po = dbo.order_header.customer_po)
--	left join dbo.part_eecustom on dbo.order_header.blanket_part = dbo.part_eecustom.part
	left join
	(	select
			OrderNo = order_header.order_no,
			QtyOnHand = sum(quantity)
		from
			dbo.object
			join part on object.part = part.part and
				part.type = 'F'
			join order_header on object.part = order_header.blanket_part
			left join location on object.location = location.code
		where
			coalesce (location.secured_location, 'N') != 'Y' and
			object.part not like '%-PT%'
		group by
			order_header.order_no,
			order_header.customer_po,
			order_header.customer_part,
			object.part) Inventory on dbo.order_header.order_no = Inventory.OrderNo
	left join
	(	select
			OrderNo = oh2.order_no,
			QtyOnHand = sum(object.quantity)
		from
			dbo.object
			join part on object.part = part.part and
				part.type = 'F'
			join order_header on object.part = order_header.blanket_part
				and
					order_header.customer = 'EEA'
			left join location on object.location = location.code
			join dbo.bill_of_material bom on
				order_header.blanket_part = bom.part
			join dbo.order_header oh2 on
				bom.parent_part = oh2.blanket_part
		where
			coalesce (location.secured_location, 'N') != 'Y' and
			object.part not like '%-PT%'
		group by
			oh2.order_no,
			oh2.customer_po,
			oh2.customer_part,
			object.part) EEAtoEEHInventory on dbo.order_header.order_no = EEAtoEEHInventory.OrderNo
where
	--coalesce(dbo.part_eecustom.CurrentRevLevel, 'N') = 'Y' or
	coalesce (order_header.status, 'O') = 'A' or
	Inventory.QtyOnHand > 0
group by
	order_header.order_no
order by
	CustomerPart,
	case
		when min(order_header.blanket_part) like '%-R%' then -1
		when coalesce (min(order_header.status), 'O') != 'A' then 0
		else 1
	end,
	InventoryPart

update
	@Inventory
set
	OhPrior = Coalesce((select sum (QtyOnHand) from @Inventory where CustomerPart = Inventory.CustomerPart and ID < Inventory.ID),0)
from
	@Inventory Inventory

update
	@Inventory
set
	OhPost = OhPrior + QtyOnHand
from
	@Inventory Inventory

declare	@DistributedReleases table
(	OrderNo int,
	OrderType char(1) NULL,
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
	Line int)

insert
	@DistributedReleases
(	OrderNo,
	OrderType ,
	OrderPart,
	CustomerPart,
	ShipToID,
	CustomerPO,
	ModelYear,
	ReleaseNo,
	OrderUnit,
	QtyRelease,
	ReleaseDT)
select
	OrderNo = Coalesce (Inventory.OrderNo, RawReleases.OrderNo),
	OrderType = nullif(RawReleases.OrderType,''),
	OrderPart = Coalesce (Inventory.InventoryPart, RawReleases.BlanketPart),
	CustomerPart = RawReleases.CustomerPart,
	ShipToID = RawReleases.ShipToID,
	CustomerPO = RawReleases.CustomerPO,
	ModelYear = RawReleases.ModelYear,
	ReleaseNo = RawReleases.ReleaseNo,
	OrderUnit = RawReleases.OrderUnit,
	QtyRelease = Coalesce (
	case
		when OhPost <= RelPost and OhPrior <= RelPrior then OhPost - RelPrior
		when OhPost >= RelPost and OhPrior <= RelPrior then RelPost - RelPrior
		when OhPost <= RelPost and OhPrior >= RelPrior then OhPost - OhPrior
		when OhPost >= RelPost and OhPrior >= RelPrior then RelPost - OhPrior
	end, QtyRelease),
	ReleaseDT
from
	@RawReleases RawReleases
	left join @Inventory Inventory on RawReleases.CustomerPart = Inventory.CustomerPart and
		RawReleases.ShipToID = Inventory.ShipToID and
		(	Inventory.OhPost > RawReleases.RelPrior and
			Inventory.OhPrior < RawReleases.RelPost)

update
	@DistributedReleases
set
	RelPost = (select sum (QtyRelease) from @DistributedReleases where OrderNo = DistributedReleases.OrderNo and ReleaseDT <= DistributedReleases.ReleaseDT),
	Line = (select count(1) from @DistributedReleases where OrderNo = DistributedReleases.OrderNo and ReleaseDT <= DistributedReleases.ReleaseDT)
from
	@DistributedReleases DistributedReleases

update
	@DistributedReleases
set
	QtyCommitted = coalesce(
	case
		when ShipperQty > RelPost then QtyRelease
		when ShipperQty > RelPost - QtyRelease then ShipperQty - (RelPost - QtyRelease)
	end, 0)
from
	@DistributedReleases DistributedReleases
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
			shipper_detail.part_original) ShipRequirements on DistributedReleases.OrderNo = ShipRequirements.OrderNo and
		DistributedReleases.OrderPart = ShipRequirements.ShipperPart

declare	@EEIQtys table
(	ShipToID varchar(20)
,	CustomerPart varchar(35)
,	DueDT datetime
,	EEIQty numeric (20,6))

insert
	@EEIQtys
select
	dr.ShipToID
,	dr.CustomerPart
,	dr.ReleaseDT
,	EEIQty =
	case
		when dr.ReleaseDT <= EEIQtyHorizon then
			(	select
					sum(eeiqty)
				from
					order_detail
				where
					destination = dr.ShipToID
				and
					customer_part = dr.CustomerPart
				and
					due_date > coalesce(
					(	select
							max(ReleaseDT)
						from
							@DistributedReleases
						where
							ShipToID = dr.ShipToID
						and
							CustomerPart = dr.CustomerPart
						and
							ReleaseDT < dr.ReleaseDT), due_date - 1)
				and
					due_date <= dr.ReleaseDT)	
		else dr.QtyRelease
	end
from
	(	select
			ShipToID,
			CustomerPart,
			ReleaseDT,
			QtyRelease = sum(QtyRelease),
			EEIQtyHorizon = dateadd(wk,
			(	select
					convert(int, c.custom4)
				from
					dbo.customer c
					join dbo.destination d on
						c.customer = d.customer

				where
					d.destination = dr.ShipToID
				and
					isnumeric(c.custom4) = 1
				and
					c.custom4 not like '%[a-z]%'), GetDate())
		from
			@DistributedReleases dr
		group by
			ShipToID,
			CustomerPart,
			ReleaseDT) dr

delete
	dbo.order_detail
from
	dbo.order_detail od
	join @DistributedReleases dr on od.order_no = dr.OrderNo
where
	od.type in ( 'P', 'F')

insert
	order_detail
(	order_no, sequence, part_number, product_name, type, quantity,
	status, notes, unit, due_date, release_no, destination,
	customer_part, row_id, flag, ship_type, packline_qty, plant,
	week_no, std_qty, our_cum, the_cum, eeiqty, price, alternate_price,
	committed_qty )
select
	order_no = dr.OrderNo,
	sequence = dr.Line + coalesce((select max (sequence) from order_detail where order_no = dr.OrderNo), 0),
	part_number = dr.OrderPart,
	product_name = (select name from dbo.part where part = dr.OrderPart),
	type = case when OrderType = 'F' then 'F' else  'P' end,
	quantity = dr.QtyRelease,
	status = '',
	notes =  case when OrderType = 'F' then  '862-Release created thru stored procedure' else  '830-Release created thru stored procedure'  end ,
	unit = (select unit from order_header where order_no = dr.OrderNo),
	due_date = dr.ReleaseDT,
	release_no = dr.ReleaseNo,
	destination = dr.ShipToID,
	customer_part = dr.CustomerPart,
	row_id = dr.Line + coalesce((select max (row_id) from order_detail where order_no = dr.OrderNo), 0),
	flag = 1,
	ship_type = 'N',
	packline_qty = 0,
	plant = (select plant from order_header where order_no = dr.OrderNo),
	week_no = datediff(dd, (select fiscal_year_begin from parameters), dr.ReleaseDT) / 7 + 1,
	std_qty = dr.QtyRelease,
	our_cum = dr.RelPost - dr.QtyRelease + coalesce((select our_cum from order_header where order_no = dr.OrderNo), (select max(the_cum) from order_detail where order_no = dr.OrderNo), 0),
	the_cum = dr.RelPost + coalesce((select our_cum from order_header where order_no = dr.OrderNo), (select max(the_cum) from order_detail where order_no = dr.OrderNo), 0),
	eeiqty = coalesce(
	(	select
			EEIQty
		from
			@EEIQtys
		where
			CustomerPart = dr.CustomerPart
		and
			ShipToID = dr.ShipToID
		and
			DueDT = dr.ReleaseDT
		and
			dr.OrderNo =
			(	select
					min(OrderNo)
				from
					@DistributedReleases dr2
				where
					CustomerPart = dr.CustomerPart
				and
					ShipToID = dr.ShipToID
				and
					ReleaseDT = dr.ReleaseDT)), 0),
	price = (select price from order_header where order_no = dr.OrderNo),
	alternate_price = (select alternate_price from order_header where order_no = dr.OrderNo),
	committed_qty = dr.QtyCommitted
from
	@DistributedReleases dr

TRUNCATE TABLE raw_830_auth
TRUNCATE TABLE raw_830_shp
TRUNCATE TABLE raw_830_release
TRUNCATE TABLE m_in_release_plan

EXECUTE msp_adjust_planning_830


SELECT	'Processed Release Plan'

/*
--execute ftsp_LogComment
--	@Comment = 'Inserted release for customer part :' + @customerpart+', destination :' + @shipto + ', release date :' + convert( varchar(16), @releasedt ) + ', quantity :' + convert( varchar(20), @releasequantity )

--execute ftsp_LogComment
--	@Comment = 'Release not saved because quantity ordered has already been shipped.'

--execute ftsp_LogComment
--	@Comment = 'Blanket order is not unique for the customer part: ' + @customerpart + ', destination: ' + @shipto + ', customer po: ' + @customerpo + ' & model year: ' + @modelyear + '. create one & then re-process.'

--execute ftsp_LogComment
--	@Comment = 'Blanket order does not exist for the customer part: ' + @customerpart + ', destination: ' + @shipto + ', customer po: ' + @customerpo + ' & model year: ' + @modelyear + '. create one & then re-process.'

insert	m_in_release_plan_exceptions (
		logid,
		customer_part,
		shipto_id,
		customer_po,
		model_year,
		release_no,
		quantity_qualifier,
		quantity,
		release_dt_qualifier,
		release_dt )
select	(	select	isnull ( max ( id ), 0 )
		  from	log
		 where	spid = @@spid ),
	@customerpart,
	@shipto,
	@customerpo,
	@modelyear,
	@releaseno,
	@quantityqualifier,
	@quantity,
	@releasedtqualifier,
	@releasedt

exec	@returncode = msp_calculate_committed_qty
	@prevorderno,
	null,
	null

--execute ftsp_LogComment
--	@Comment = 'Calculated committed quantity for order:  ' + convert ( char ( 8 ), @prevorderno ) + '.'

--execute ftsp_LogComment
--	@Comment = 'Failed to calculated committed quantity for order:  ' + convert ( char ( 8 ), @prevorderno ) + '.  Order not found.'

--execute ftsp_LogComment
--	@Comment = 'Inbound release plan does not exist.  Check configuration and reprocess.'

--execute ftsp_LogComment
--	@Comment = 'Processing complete.' + convert ( varchar(20), getdate ( ) )

--	53. Remove processed inbound data and Update EEI Qty on Refreshed Release Plan.

return 0
*/



GO

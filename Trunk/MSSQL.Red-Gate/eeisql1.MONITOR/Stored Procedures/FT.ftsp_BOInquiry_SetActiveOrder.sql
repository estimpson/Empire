SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[ftsp_BOInquiry_SetActiveOrder]
	@DestinationCode varchar(20)
,	@CustomerPart varchar(35)
,	@NewActiveOrder int
,	@Result int out
as
/*

begin transaction
go

declare
	@ProcResult int

exec FT.ftsp_BOInquiry_SetActiveOrder
	@DestinationCode = 'MAGNAITC'
,	@CustomerPart = '301-11803DX9'
,	@NewActiveOrder = 15924
,	@Result = @ProcResult out
go

select
	*
from
	dbo.order_detail od
where
	od.order_no in (15806, 15924)

rollback
go

*/

set ansi_warnings off
set nocount on

/*	Make the active order be the current rev level.*/
declare
	@basePart char(7)

select
	@basePart = left(oh.blanket_part, 7)
from
	dbo.order_header oh
where
	oh.order_no = @NewActiveOrder

update
	pe
set
	CurrentRevLevel =
		case
			when pe.part = oh.blanket_part then 'Y'
			else 'N'
		end
from
	dbo.part_eecustom pe
	join dbo.part pFin
		on pFin.type = 'F'
		and pFin.part = pe.part
	join dbo.order_header oh
		on oh.order_no = @NewActiveOrder
where
	pe.part like @basePart + '%'
	
declare	@OldActiveOrder numeric(8, 0)

select
	@OldActiveOrder = SalesOrderNo
from
	BlanketOrderInquiry
where
	DestinationCode = @DestinationCode
	and CustomerPart = @CustomerPart
	and ActiveFlag = 1

update
	dbo.order_header
set	
	status = 'A'
,	our_cum = coalesce
		(	(	select
					our_cum
				from
					dbo.order_header
				where
					order_no = @OldActiveOrder
				)
		,	our_cum
		)
where
	order_no = @NewActiveOrder

update
	dbo.order_header
set	
	status = 'O'
where
	order_no = @OldActiveOrder

--	Move releases to new active order, leaving behind enough to cover inventory
--	of old active order.
declare	@ActiveOrderReleases table
(	 ID int identity primary key
,	OrderNo int
,	BlanketPart varchar(25)
,	CustomerPart varchar(35)
,	ShipToID varchar(20)
,	ReleaseNo varchar(30)
,	OrderUnit char(2)
,	QtyRelease numeric(20, 6)
,	StdQtyRelease numeric(20, 6)
,	RelPrior numeric(20, 6)
,	RelPost numeric(20, 6)
,	ReleaseDT datetime
,	ReleaseType char(1)
,	Notes varchar(255)
)

insert
	@ActiveOrderReleases
(	OrderNo
,	BlanketPart
,	CustomerPart
,	ShipToID
,	ReleaseNo
,	OrderUnit
,	QtyRelease
,	StdQtyRelease
,	ReleaseDT
,	ReleaseType
,	Notes
)
select
	OrderNo = @NewActiveOrder
,	BlanketPart =
		(	select
				blanket_part
		   from
				dbo.order_header
		   where
				order_no = @NewActiveOrder
		)
,	CustomerPart = min(od.customer_part)
,	ShipToID = min(od.destination)
,	ReleaseNo = min(od.release_no)
,	OrderUnit = min(od.unit)
,	QtyRelease = sum(od.quantity)
,	StdQtyRelease = sum(od.std_qty)
,	ReleaseDT = od.due_date
,	ReleaseType = od.type
,	Notes = min(od.notes)
from
	dbo.order_detail od
where
	od.order_no in (@OldActiveOrder, @NewActiveOrder)
group by
	od.type
,	od.due_date
order by
	od.due_date

update
	@ActiveOrderReleases
set	
	RelPrior = coalesce
		(	(	select
					sum(StdQtyRelease)
				from
					@ActiveOrderReleases
				where
					ID < aor.ID
			)
		,	0
		)
from
	@ActiveOrderReleases aor

update
	@ActiveOrderReleases
set	
	RelPost = RelPrior + StdQtyRelease
from
	@ActiveOrderReleases aor

declare	@QtyOnHand numeric(20, 6)

select
	@QtyOnHand = sum(quantity)
from
	dbo.object o
	join dbo.order_header oh
		on o.part = oh.blanket_part
	left join dbo.location l
		on o.location = l.code
where
	coalesce(l.secured_location, 'N') != 'Y'
	and oh.order_no = @OldActiveOrder

declare
	@DistributedReleases table
(	 ID int identity primary key
,	OrderNo int
,	OrderPart varchar(25)
,	CustomerPart varchar(35)
,	ShipToID varchar(20)
,	ReleaseNo varchar(30)
,	OrderUnit char(2)
,	QtyRelease numeric(20, 6)
,	RelPost numeric(20, 6)
,	QtyCommitted numeric(20, 6)
,	ReleaseDT datetime
,	ReleaseType char(1)
,	Notes varchar(255)
,	Line int
)

insert
	@DistributedReleases
(	 OrderNo
,	OrderPart
,	CustomerPart
,	ShipToID
,	ReleaseNo
,	OrderUnit
,	QtyRelease
,	ReleaseDT
,	ReleaseType
,	Notes
)
select
	OrderNo = oh.order_no
,	OrderPart = oh.blanket_part
,	CustomerPart = aor.CustomerPart
,	ShipToID = aor.ShipToID
,	ReleaseNo = aor.ReleaseNo
,	OrderUnit = aor.OrderUnit
,	QtyRelease = case when @QtyOnHand <= aor.RelPost then @QtyOnHand - aor.RelPrior
					  when @QtyOnHand >= aor.RelPost then aor.RelPost - aor.RelPrior
				 end
,	aor.ReleaseDT
,	aor.ReleaseType
,	aor.Notes
from
	@ActiveOrderReleases aor
	join dbo.order_header oh
		on oh.order_no = @OldActiveOrder
where
	@QtyOnHand > aor.RelPrior
union all
select
	OrderNo = aor.OrderNo
,	OrderPart = aor.BlanketPart
,	CustomerPart = aor.CustomerPart
,	ShipToID = aor.ShipToID
,	ReleaseNo = aor.ReleaseNo
,	OrderUnit = aor.OrderUnit
,	QtyRelease = case when @QtyOnHand > aor.RelPrior then aor.RelPost - @QtyOnHand
					  else aor.RelPost - aor.RelPrior
				 end
,	aor.ReleaseDT
,	aor.ReleaseType
,	aor.Notes
from
	@ActiveOrderReleases aor
where
	@QtyOnHand <= aor.RelPost
order by
	OrderNo
,	ReleaseDT

update
	@DistributedReleases
set	
	RelPost =
		(   select
				sum(QtyRelease)
			from
				@DistributedReleases
			where
				OrderNo = DistributedReleases.OrderNo
				and ID <= DistributedReleases.ID
		)
,	Line =
		(	select
				count(1)
			from
				@DistributedReleases
			where
				OrderNo = DistributedReleases.OrderNo
				and ID <= DistributedReleases.ID
		 )
from
	@DistributedReleases DistributedReleases

update
	@DistributedReleases
set	
	QtyCommitted = coalesce(case when ShipperQty > RelPost then QtyRelease
								 when ShipperQty > RelPost - QtyRelease then ShipperQty - (RelPost - QtyRelease)
							end, 0)
from
	@DistributedReleases DistributedReleases
	left join
		(	select
				OrderNo = shipper_detail.order_no
			,	ShipperPart = shipper_detail.part_original
			,	ShipperQty = sum(qty_required)
			from
				shipper_detail
				join shipper
					on shipper_detail.shipper = shipper.id
			where
				shipper.type is null
				and shipper.status in ('O', 'A', 'S')
			group by
				shipper_detail.order_no
			,	shipper_detail.part_original
		) ShipRequirements
		on DistributedReleases.OrderNo = ShipRequirements.OrderNo
		   and DistributedReleases.OrderPart = ShipRequirements.ShipperPart

declare
	@EEIQtys table
(	ShipToID varchar(20)
,	CustomerPart varchar(35)
,	DueDT datetime
,	EEIQty numeric(20, 6)
)

insert
	@EEIQtys
select
	dr.ShipToID
,	dr.CustomerPart
,	dr.ReleaseDT
,	EEIQty = case when dr.ReleaseDT <= EEIQtyHorizon
				  then (
						select
							sum(eeiqty)
						from
							order_detail
						where
							destination = dr.ShipToID
							and customer_part = dr.CustomerPart
							and due_date > coalesce((
													 select
														max(ReleaseDT)
													 from
														@DistributedReleases
													 where
														ShipToID = dr.ShipToID
														and CustomerPart = dr.CustomerPart
														and ReleaseDT < dr.ReleaseDT
													), due_date - 1)
							and due_date <= dr.ReleaseDT
					   )
				  else dr.QtyRelease
			 end
from
	(	select
			ShipToID
		,	CustomerPart
		,	ReleaseDT
		,	QtyRelease = sum(QtyRelease)
		,	EEIQtyHorizon = dateadd(wk,
				(	select
						convert(int, c.custom4)
					from
						dbo.customer c
						join dbo.destination d
							on c.customer = d.customer
					where
						d.destination = dr.ShipToID
						and isnumeric(c.custom4) = 1
						and c.custom4 not like '%[a-z]%'
				), getdate())
		from
			@DistributedReleases dr
		group by
			ShipToID
		,	CustomerPart
		,	ReleaseDT
	) dr

delete
	dbo.order_detail
from
	dbo.order_detail od
	join @DistributedReleases dr
		on od.order_no = dr.OrderNo

insert
	order_detail
(	order_no
,	sequence
,	part_number
,	product_name
,	type
,	quantity
,	status
,	notes
,	unit
,	due_date
,	release_no
,	destination
,	customer_part
,	row_id
,	flag
,	ship_type
,	packline_qty
,	plant
,	week_no
,	std_qty
,	our_cum
,	the_cum
,	eeiqty
,	price
,	alternate_price
,	committed_qty 
)
select
	order_no = dr.OrderNo
,	sequence = dr.Line + coalesce
		(	(	select
					max(sequence)
				from
					order_detail
				where
					order_no = dr.OrderNo
			)
		,	0
		)
,	part_number = dr.OrderPart
,	product_name =
		(	select
			name
		from
			dbo.part
		where
			part = dr.OrderPart
		)
,	type = dr.ReleaseType
,	quantity = dr.QtyRelease
,	status = ''
,	notes = dr.Notes
,	unit =
		(	select
				unit
			from
				order_header
			where
				order_no = dr.OrderNo
		)
,	due_date = dr.ReleaseDT
,	release_no = dr.ReleaseNo
,	destination = dr.ShipToID
,	customer_part = dr.CustomerPart
,	row_id = dr.Line + coalesce
		(	(	select
					max(row_id)
				from
					order_detail
				where
					order_no = dr.OrderNo
			)
		,	0
		)
,	flag = 1
,	ship_type = 'N'
,	packline_qty = 0
,	plant =
		(	select
				plant
			from
				order_header
			where
				order_no = dr.OrderNo
		)
,	week_no = datediff(dd,
		(	select
				fiscal_year_begin
			from
				parameters
		), dr.ReleaseDT) / 7 + 1
,	std_qty = dr.QtyRelease
,	our_cum = dr.RelPost - dr.QtyRelease + coalesce((
													 select
														our_cum
													 from
														order_header
													 where
														order_no = dr.OrderNo
													), (
														select
															max(the_cum)
														from
															order_detail
														where
															order_no = dr.OrderNo
													   ), 0)
,	the_cum = dr.RelPost + coalesce((
									 select
										our_cum
									 from
										order_header
									 where
										order_no = dr.OrderNo
									), (
										select
											max(the_cum)
										from
											order_detail
										where
											order_no = dr.OrderNo
									   ), 0)
,	eeiqty = coalesce((
					   select
						EEIQty
					   from
						@EEIQtys
					   where
						CustomerPart = dr.CustomerPart
						and ShipToID = dr.ShipToID
						and DueDT = dr.ReleaseDT
						and dr.OrderNo = (
										  select
											min(OrderNo)
										  from
											@DistributedReleases dr2
										  where
											CustomerPart = dr.CustomerPart
											and ShipToID = dr.ShipToID
											and ReleaseDT = dr.ReleaseDT
										 )
					  ), dr.QtyRelease)
,	price = (
			 select
				price
			 from
				order_header
			 where
				order_no = dr.OrderNo
			)
,	alternate_price = (
					   select
						alternate_price
					   from
						order_header
					   where
						order_no = dr.OrderNo
					  )
,	committed_qty = dr.QtyCommitted
from
	@DistributedReleases dr
GO

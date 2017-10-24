SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








/*
Create procedure FX.dbo.usp_Shipping_ShipoutReleiveOrders
*/

--use FX
--go

--if	objectproperty(object_id('dbo.usp_Shipping_ShipoutReleiveOrders'), 'IsProcedure') = 1 begin
--	drop procedure dbo.usp_Shipping_ShipoutReleiveOrders
--end
--go

--create procedure dbo.usp_Shipping_ShipoutReleiveOrders
CREATE procedure [dbo].[usp_Shipping_ShipoutReleiveOrders]
	@ShipperID integer
,	@TranDT datetime = null out
,	@Result integer = null out
,	@Debug integer = 1
as

--2017-09-17 Andre S. Boulanger FT, LLC : Corrected issue with insert to #shipmentSummary table




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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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
/*	Record Audit data for all key decision data used in this process. */
insert
	FT.AuditRAN_shipper
(	ShipperID
,	AuditSource
,	TranDT
,	id
,	destination
)
select
	ShipperID = @ShipperID
,	AuditSource = 'Ship Out'
,	TranDT = @TranDT
,	s.id
,	s.destination
from
	dbo.shipper s
where
	s.id = @ShipperID

insert
	FT.AuditRAN_shipper_detail
(	ShipperID
,	AuditSource
,	TranDT
,	shipper
,	customer_part
,	qty_required
,	qty_packed
)
select
	ShipperID = @ShipperID
,	AuditSource = 'Ship Out'
,	TranDT = @TranDT
,	sd.shipper
,	sd.customer_part
,	sd.qty_required
,	sd.qty_packed
from
	dbo.shipper_detail sd
where
	sd.shipper = @ShipperID

insert
	FT.AuditRAN_order_header
(	ShipperID
,	AuditSource
,	TranDT
,	order_no
,	our_cum
)
select
	ShipperID = @ShipperID
,	AuditSource = 'Ship Out'
,	TranDT = @TranDT
,	oh.order_no
,	oh.our_cum
from
	dbo.order_header oh
	join dbo.BlanketOrderAlternates boa
		join dbo.BlanketOrderInquiry boi
			on boi.SalesOrderNo = boa.ActiveOrderNo
		join dbo.shipper_detail sd
			join dbo.shipper s
				on s.id = sd.shipper
			on boi.DestinationCode = s.destination
			and boi.CustomerPart = sd.customer_part
		on oh.order_no = boa.AlternateOrderNo
where
	sd.shipper = @ShipperID

insert
	FT.AuditRAN_order_detail
(	ShipperID
,	AuditSource
,	TranDT
,	order_no
,	destination
,	customer_part
,	due_date
,	release_no
,	part_number
,	quantity
,	std_qty
,	id
)
select
	ShipperID = @ShipperID
,	AuditSource = 'Ship Out'
,	TranDT = @TranDT
,	od.order_no
,	od.destination
,	od.customer_part
,	od.due_date
,	od.release_no
,	od.part_number
,	od.quantity
,	od.std_qty
,	od.id
from
	dbo.order_detail od
	join dbo.shipper_detail sd
		join dbo.shipper s
			on s.id = sd.shipper
		on s.destination = od.destination
		and sd.customer_part = od.customer_part
where
	sd.shipper = @ShipperID

insert
	FT.AuditRAN_BlanketOrderAlternates
(	ShipperID
,	AuditSource
,	TranDT
,	ActiveOrderNo
)
select
	ShipperID = @ShipperID
,	AuditSource = 'Ship Out'
,	TranDT = @TranDT
,	boa.ActiveOrderNo
from
	dbo.BlanketOrderAlternates boa
		join dbo.BlanketOrderInquiry boi
			on boi.SalesOrderNo = boa.ActiveOrderNo
	join dbo.shipper_detail sd
		join dbo.shipper s
			on s.id = sd.shipper
		on s.destination = boi.DestinationCode
		and sd.customer_part = boi.CustomerPart
where
	sd.shipper = @ShipperID

insert
	FT.AuditRAN_BlanketOrderInquiry
(	ShipperID
,	AuditSource
,	TranDT
,	SalesOrderNo
,	DestinationCode
,	CustomerPart
)
select
	ShipperID = @ShipperID
,	AuditSource = 'Ship Out'
,	TranDT = @TranDT
,	boi.SalesOrderNo
,	boi.DestinationCode
,	boi.CustomerPart
from
	dbo.BlanketOrderInquiry boi
	join dbo.shipper_detail sd
		join dbo.shipper s
			on s.id = sd.shipper
		on s.destination = boi.DestinationCode
		and sd.customer_part = boi.CustomerPart
where
	sd.shipper = @ShipperID

/*	Calculate a summary of the packed quantity against each customer part
	and the "Active" order.
	
	If the scheduled order (shipper_detail.order_no) is for a prototype
	part, or doesn't have an "Active" order, or is a normal order,
	then the "Active" order is the scheduled order.*/
create table
	#shipmentSummary 
(	ShipTo varchar(25)
,	CustomerPart varchar(30)
,	QtyPacked numeric(20,6)
,	ActiveOrderNo numeric(8,0)
,	primary key
	(	ShipTo
	,	CustomerPart
	)
)

insert
	#shipmentSummary
(	ShipTo
,	CustomerPart
,	QtyPacked
,	ActiveOrderNo
)
select
	ShipTo = s.destination
,	CustomerPart = sd.customer_part
,	QtyPacked = sum(sd.qty_packed) -- was sd.qty_required Andre S. Boulanger FT, LLC 2017-09-11
,	ActiveOrderNo = max(coalesce(boa.ActiveOrderNo, sd.order_no))
from
	dbo.shipper_detail sd
		join dbo.shipper s
			on s.id = sd.shipper
		join dbo.order_header ohGSS
			on sd.order_no = ohGSS.order_no
	left join dbo.BlanketOrderAlternates boa
		join dbo.BlanketOrderInquiry boi
			on boi.SalesOrderNo = boa.ActiveOrderNo
		on boi.CustomerPart = sd.customer_part
		and boi.DestinationCode = s.destination	
		and boa.AlternateOrderNo = boa.ActiveOrderNo
		and ohGSS.blanket_part not like '%-PT%'
		and ohGSS.order_type = 'B'
where
	sd.shipper = @ShipperID
group by
	s.destination
,	sd.customer_part

if	@Debug = 1 begin
	select
		*
	from
		#shipmentSummary
end

/*	Caculate requirements summarized by Active Order, Release Date, Release No.
	
	Get all requirements for alternate orders unless this was an order for prototypes,
	orders that don't have an "Active" order, or normal orders.
*/
create table
	#requirements
(	RowID int not null IDENTITY(1, 1) primary key
,	ActiveOrderNo numeric(8,0)
,	ShipTo varchar(25)
,	CustomerPart varchar(30)
,	ReleaseDate datetime
,	ReleaseNo varchar(30)
,	QtyRequired numeric(20,6)
,	PriorAccum numeric(20,6)
,	PostAccum numeric(20,6)
,	unique
	(	ShipTo
	,	CustomerPart
	,	ReleaseDate
	,	ReleaseNo
	)
,	unique
	(	ActiveOrderNo
	,	ReleaseDate
	,	ReleaseNo
	)
)

insert
	#requirements
(	ActiveOrderNo
,	ShipTo
,	CustomerPart
,	ReleaseDate
,	ReleaseNo
,	QtyRequired
)

--No release number order_detail rows causing unique key violation. Modified 03/15/2016 ASB FT, LLC
select
	ActiveOrderNo = ss.ActiveOrderNo
,	ShipTo = od.destination
,	CustomerPart = od.customer_part
,	ReleaseDate = od.due_date
,	ReleaseNo = coalesce(od.release_no, 'ZZZ_' + convert(varchar(25), od.row_id))
,	QtyRequired = sum(od.std_qty)
from
	dbo.order_detail od
	join #shipmentSummary ss
		left join dbo.BlanketOrderAlternates boa
			on boa.ActiveOrderNo = ss.ActiveOrderNo
		on od.order_no = coalesce(boa.AlternateOrderNo, ss.ActiveOrderNo)
group by
	ss.ActiveOrderNo
,	od.destination
,	od.customer_part
,	od.due_date
 , coalesce(od.release_no, 'ZZZ_' + convert(varchar(25), od.row_id))
order by
	od.destination
,	od.customer_part
,	od.due_date
,	  coalesce(od.release_no, 'ZZZ_' + convert(varchar(25), od.row_id))
update
	r
set	PostAccum =
		(	select
				sum(r1.QtyRequired)
			from
				#requirements r1
			where
				r1.ActiveOrderNo = r.ActiveOrderNo
				and r1.RowID <= r.RowID
		)
from
	#requirements r

update
	r
set	PriorAccum = r.PostAccum - r.QtyRequired
from
	#requirements r

if	@Debug = 1 begin
	select
		*
	from
		#requirements r
end

/*	Calculate the releases shipped summarized by Active Order, Release Date, and ReleaseNo. */
create table
	#releasesShipped
(	RowID int not null IDENTITY(1, 1) primary key
,	ActiveOrderNo numeric(8,0)
,	ShipTo varchar(25)
,	CustomerPart varchar(30)
,	ReleaseDate datetime
,	ReleaseNo varchar(30)
,	ReleaseQty numeric(20,6)
,	PriorAccum numeric(20,6)
,	PostAccum numeric(20,6)
,	unique
	(	ActiveOrderNo
	,	ReleaseDate
	,	ReleaseNo
	)
,	unique
	(	ShipTo
	,	CustomerPart
	,	ReleaseDate
	,	ReleaseNo
	)
)

insert
	#releasesShipped
(	ActiveOrderNo
,	ShipTo
,	CustomerPart
,	ReleaseDate
,	ReleaseNo
,	ReleaseQty
,	PriorAccum
,	PostAccum
)
select
	ActiveOrderNo = r.ActiveOrderNo
,	ShipTo = r.ShipTo
,	CustomerPart = r.CustomerPart
,	ReleaseDate = r.ReleaseDate
,	ReleaseNo = r.ReleaseNo
,	ReleaseQty =
		case
			when ss.QtyPacked >= r.PostAccum then r.QtyRequired
			else ss.QtyPacked - r.PriorAccum
		end
,	PriorAccum = r.PriorAccum
,	PostAccum =
		case
			when ss.QtyPacked >= r.PostAccum then r.PostAccum
			else ss.QtyPacked
		end
from
	#requirements r
	join #shipmentSummary ss
		on ss.ActiveOrderNo = r.ActiveOrderNo
where
	r.PriorAccum < ss.QtyPacked

if	@Debug = 1 begin
	select
		*
	from
		#releasesShipped
end

/*	Calculate the releases to be relieved...*/
/*	...	get the open releases for this order in the order they are to be releived. */
create table
	#releases
(	RowID int not null IDENTITY(1, 1) primary key
,	OrderNo numeric(8,0)
,	ActiveOrderNo numeric(8,0)
,	ShipTo varchar(25)
,	CustomerPart varchar(30)
,	ReleaseDate datetime
,	ReleaseNo varchar(30)
,	PartCode varchar(25)
,	QtyRequired numeric(20,6)
,	PriorAccum numeric(20,6)
,	PostAccum numeric(20,6)
,	ReleaseID int
,	ReleiveQty numeric(20,6)
,	DeleteRelease bit default(0)
,	unique
	(	OrderNo
	,	RowID
	)
,	unique
	(	ShipTo
	,	CustomerPart
	,	RowID
	)
)

insert
	#releases
(	OrderNo
,	ActiveOrderNo
,	ShipTo
,	CustomerPart
,	ReleaseDate
,	ReleaseNo
,	PartCode
,	QtyRequired
,	ReleaseID
)
select
	OrderNo = od.order_no
,	ActiveOrderNo = ss.ActiveOrderNo
,	ShipTo = od.destination
,	CustomerPart = od.customer_part
,	ReleaseDate = od.due_date
,	ReleaseNo = coalesce(od.release_no, '')
,	PartCode = od.part_number
,	QtyRequired = od.std_qty
,	ReleaseID = od.id
from
	dbo.order_detail od
	join #shipmentSummary ss
		left join dbo.BlanketOrderAlternates boa
			on boa.ActiveOrderNo = ss.ActiveOrderNo
		on od.order_no = coalesce(boa.AlternateOrderNo, ss.ActiveOrderNo)
order by
	od.destination
,	od.customer_part
,	od.due_date
,	od.release_no
,	od.part_number -- Use ordering for release distribution.  Perhaps not critical because redistribution should handle correctly.

update
	r
set	PostAccum =
		(	select
				sum(r1.QtyRequired)
			from
				#releases r1
			where
				r1.ActiveOrderNo = r.ActiveOrderNo
				and r1.RowID <= r.RowID
		)
from
	#releases r

update
	r
set	PriorAccum = r.PostAccum - r.QtyRequired
from
	#releases r

/*	...	calculate the quantity to be relieved. */
update
	r
set	ReleiveQty =
		case
			when ss.QtyPacked >= r.PostAccum then r.QtyRequired
			else ss.QtyPacked - r.PriorAccum
		end
,	DeleteRelease =
		case
			when ss.QtyPacked >= r.PostAccum then 1
			else 0
		end
from
	#releases r
	join #shipmentSummary ss
		on ss.ActiveOrderNo = r.ActiveOrderNo
where
	r.PriorAccum < ss.QtyPacked

/*	Write RAN history (AutoLiv). */
if	exists
	(	select
			*
		from
			#releases r
		where
			r.PartCode like 'ALI%'
	) begin
	
	--- <Insert rows="*">
	set	@TableName = 'AutoLivRanNumbersShipped'

	insert
		AutoLivRanNumbersShipped
	(	OrderNo
	,	ShipDate
	,	Qty
	,	RanNumber
	,	Shipper
	)
	select
		OrderNo = r.OrderNo
	,	ShipDate = FT.fn_TruncDate('day', s.date_shipped)
	,	Qty =
			case
				when r.PostAccum < rs.PriorAccum then 0
				when r.PriorAccum > rs.PostAccum then 0
				when r.PostAccum >= rs.PostAccum and r.PriorAccum <= rs.PriorAccum then rs.PostAccum - rs.PriorAccum
				when r.PostAccum < rs.PostAccum and r.PriorAccum > rs.PriorAccum then r.PostAccum - r.PriorAccum
				when r.PostAccum >= rs.PostAccum and r.PriorAccum > rs.PriorAccum then rs.PostAccum - r.PriorAccum
				when r.PostAccum < rs.PostAccum and r.PriorAccum <= rs.PriorAccum then r.PostAccum - rs.PriorAccum
			end
	,	RanNumber = rs.ReleaseNo
	,	Shipper = s.id
	from
		#releases r
		join #releasesShipped rs
			on rs.ActiveOrderNo = r.ActiveOrderNo
			and rs.ReleaseDate = r.ReleaseDate
		join dbo.shipper s
			on s.id = @ShipperID
	where
		r.PostAccum > rs.PriorAccum
		and r.PriorAccum < rs.PostAccum

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Insert>
end

/*	Write RAN history (ADAC). */
if	exists
	(	select
			*
		from
			#releases r
		where
			r.PartCode like 'ADC%'
	) begin
	
	--- <Insert rows="*">
	set	@TableName = 'ADACRanNumbersShipped'

	insert
		ADACRanNumbersShipped
	(	OrderNo
	,	ShipDate
	,	Qty
	,	RanNumber
	,	Shipper
	)
	select
		OrderNo = r.OrderNo
	,	ShipDate = FT.fn_TruncDate('day', s.date_shipped)
	,	Qty =
			case
				when r.PostAccum < rs.PriorAccum then 0
				when r.PriorAccum > rs.PostAccum then 0
				when r.PostAccum >= rs.PostAccum and r.PriorAccum <= rs.PriorAccum then rs.PostAccum - rs.PriorAccum
				when r.PostAccum < rs.PostAccum and r.PriorAccum > rs.PriorAccum then r.PostAccum - r.PriorAccum
				when r.PostAccum >= rs.PostAccum and r.PriorAccum > rs.PriorAccum then rs.PostAccum - r.PriorAccum
				when r.PostAccum < rs.PostAccum and r.PriorAccum <= rs.PriorAccum then r.PostAccum - rs.PriorAccum
			end
	,	RanNumber = rs.ReleaseNo
	,	Shipper = s.id
	from
		#releases r
		join #releasesShipped rs
			on rs.ActiveOrderNo = r.ActiveOrderNo
			and rs.ReleaseDate = r.ReleaseDate
		join dbo.shipper s
			on s.id = @ShipperID
	where
		r.PostAccum > rs.PriorAccum
		and r.PriorAccum < rs.PostAccum

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Insert>
end

/*	Write RAN history (NAL). */

if	exists
	(	select
			*
		from
			#releases r
		where
			r.PartCode like 'NAL%'
	) begin
	
	--- <Insert rows="*">
	set	@TableName = 'NALRanNumbersShipped'

	insert
		NALRanNumbersShipped
	(	OrderNo
	,	ShipDate
	,	Qty
	,	RanNumber
	,	Shipper
	)
	select
		OrderNo = r.OrderNo
	,	ShipDate = FT.fn_TruncDate('day', s.date_shipped)
	,	Qty =
			case
				when r.PostAccum < rs.PriorAccum then 0
				when r.PriorAccum > rs.PostAccum then 0
				when r.PostAccum >= rs.PostAccum and r.PriorAccum <= rs.PriorAccum then rs.PostAccum - rs.PriorAccum
				when r.PostAccum < rs.PostAccum and r.PriorAccum > rs.PriorAccum then r.PostAccum - r.PriorAccum
				when r.PostAccum >= rs.PostAccum and r.PriorAccum > rs.PriorAccum then rs.PostAccum - r.PriorAccum
				when r.PostAccum < rs.PostAccum and r.PriorAccum <= rs.PriorAccum then r.PostAccum - rs.PriorAccum
			end
	,	RanNumber = rs.ReleaseNo
	,	Shipper = s.id
	from
		#releases r
		join #releasesShipped rs
			on rs.ActiveOrderNo = r.ActiveOrderNo
			and rs.ReleaseDate = r.ReleaseDate
		join dbo.shipper s
			on s.id = @ShipperID
	where
		r.PostAccum > rs.PriorAccum
		and r.PriorAccum < rs.PostAccum

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Insert>
end

/*	Write Discrete PO shipment history (Blanket POs that have SPOT in order_header.customer_po). */
--
if	exists
	(	select
			*
		from
			#releases r
		where
			r.OrderNo in ( Select order_no from ft.vwDiscreteReleaseOrders )
	) begin
	
	--- <Insert rows="*">
	set	@TableName = 'DiscretePONumbersShipped'

	insert
		DiscretePONumbersShipped
	(	OrderNo
	,	ShipDate
	,	Qty
	,	DiscretePONumber
	,	Shipper
	)
	select
		OrderNo = r.OrderNo
	,	ShipDate = FT.fn_TruncDate('day', s.date_shipped)
	,	Qty =
			case
				when r.PostAccum < rs.PriorAccum then 0
				when r.PriorAccum > rs.PostAccum then 0
				when r.PostAccum >= rs.PostAccum and r.PriorAccum <= rs.PriorAccum then rs.PostAccum - rs.PriorAccum
				when r.PostAccum < rs.PostAccum and r.PriorAccum > rs.PriorAccum then r.PostAccum - r.PriorAccum
				when r.PostAccum >= rs.PostAccum and r.PriorAccum > rs.PriorAccum then rs.PostAccum - r.PriorAccum
				when r.PostAccum < rs.PostAccum and r.PriorAccum <= rs.PriorAccum then r.PostAccum - rs.PriorAccum
			end
	,	DiscretePONumber = rs.ReleaseNo
	,	Shipper = s.id
	from
		#releases r
		join #releasesShipped rs
			on rs.ActiveOrderNo = r.ActiveOrderNo
			and rs.ReleaseDate = r.ReleaseDate
		join dbo.shipper s
			on s.id = @ShipperID
	where
		r.PostAccum > rs.PriorAccum
		and r.PriorAccum < rs.PostAccum

	select
		@Error = @@Error,
		@RowCount = @@Rowcount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Insert>
end


/*	Relieve order detail... */
/*	... remove fully met releases. */
--- <Delete rows="*">
set	@TableName = 'dbo.order_detail'

delete
	od
from
	dbo.order_detail od
	join #releases r
		join #shipmentSummary ss
			on ss.ActiveOrderNo = r.ActiveOrderNo
			and ss.QtyPacked >= r.PostAccum
		on od.id = r.ReleaseID
where
	r.DeleteRelease = 1

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Delete>

/*	... adjust partially met releases. */
--- <Update rows="*">
set	@TableName = 'dbo.order_detail'

update
	od
set
	quantity = od.quantity - r.ReleiveQty
,	std_qty = od.std_qty - r.ReleiveQty
from
	dbo.order_detail od
	join #releases r
		join #shipmentSummary ss
			on ss.ActiveOrderNo = r.ActiveOrderNo
			and ss.QtyPacked >= r.PostAccum
		on od.id = r.ReleaseID

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>

/*	Update the accum shipped on all impacted blanket orders... */
--- <Update rows="*">
set	@TableName = 'dbo.order_header'

update
	oh
set	our_cum = coalesce(ohActive.our_cum, oh.our_cum, 0) + ss.QtyPacked
from
	#shipmentSummary ss
		left join dbo.BlanketOrderAlternates boa
			join dbo.order_header ohActive
				on ohActive.order_no = boa.ActiveOrderNo
			on boa.ActiveOrderNo = ss.ActiveOrderno
	join dbo.order_header oh
		on oh.order_no = coalesce(boa.AlternateOrderNo, ss.ActiveOrderNo)
where
	oh.order_type = 'B'

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>

/*	Update the accum shipped on ship history. */
--- <Update rows="1+">
set	@TableName = 'dbo.shipper_detail'

update
	sd
set	accum_shipped = oh.our_cum
from
    dbo.shipper_detail sd
    join dbo.shipper s
        on s.id = sd.shipper
    join dbo.order_header oh
        on oh.order_no = sd.order_no
where
    sd.shipper = @ShipperID

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <= 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>

/*	Redistribute releases affected by shipment... */
/*	... get all remaining releases on orders that are affected by shipment.*/
if	object_id('tempdb.dbo.##BlanketOrderReleases_Edit') is null begin

	create table ##BlanketOrderReleases_Edit
	(	SPID int default @@SPID
	,	Status int not null default(0)
	,	Type int not null default(0)
	,	ActiveOrderNo int
	,	ReleaseNo varchar(30)
	,	ReleaseDT datetime
	,	ReleaseType char(1)
	,	QtyRelease numeric(20,6)
	,	RowID int identity(1,1) primary key clustered
	,	RowCreateDT datetime default(getdate())
	,	RowCreateUser sysname default(suser_name())
	,	RowModifiedDT datetime default(getdate())
	,	RowModifiedUser sysname default(suser_name())
	,	UNIQUE NONCLUSTERED
		(	SPID
		,	ActiveOrderNo
		,	ReleaseNo
		,	ReleaseDT
		)
	)
END

DELETE
	##BlanketOrderReleases_Edit
WHERE
	SPID = @@SPID

INSERT
	##BlanketOrderReleases_Edit
(	ActiveOrderNo
,	ReleaseNo
,	ReleaseDT
,	ReleaseType
,	QtyRelease
)
SELECT
	bor.ActiveOrderNo
,   bor.ReleaseNo
,   bor.ReleaseDT
,	bor.ReleaseType
,   bor.QtyRelease
FROM
	dbo.BlanketOrderReleases bor
WHERE
	bor.ActiveOrderNo IN
	(	SELECT
			ActiveOrderNo
		FROM
			#shipmentSummary ss
	)
ORDER BY
	bor.ReleaseDT
,	bor.ReleaseNo

IF	@Debug = 1 BEGIN
	SELECT
		*
	FROM
		##BlanketOrderReleases_Edit bore
	WHERE
		bore.SPID = @@SPID
END

/*	... distribute remaining releases. */
--- <Call>	
SET	@CallProcName = 'dbo.usp_GetBlanketOrderDistributedReleases'
EXECUTE
	@ProcReturn = dbo.usp_GetBlanketOrderDistributedReleases
	@TranDT = @TranDT OUT
,	@Result = @ProcResult OUT
,	@Debug = @Debug

SET	@Error = @@Error
IF	@Error != 0 BEGIN
	SET	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	ROLLBACK TRAN @ProcName
	RETURN
		@Result
END
IF	@ProcReturn != 0 BEGIN
	SET	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	ROLLBACK TRAN @ProcName
	RETURN
		@Result
END
IF	@ProcResult != 0 BEGIN
	SET	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	ROLLBACK TRAN @ProcName
	RETURN
		@Result
END
--- </Call>

IF	@Debug = 1 BEGIN
	SELECT
		*
	FROM
		##BlanketOrderDistributeReleases_Edit bodre
	WHERE
		bodre.SPID = @@SPID
END

/*	... write remaining distributed releases. */
--- <Call>	
SET	@CallProcName = 'dbo.usp_SaveBlanketOrderDistributedReleases'
EXECUTE
	@ProcReturn = dbo.usp_SaveBlanketOrderDistributedReleases
	@TranDT = @TranDT OUT
,	@Result = @ProcResult OUT

SET	@Error = @@Error
IF	@Error != 0 BEGIN
	SET	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	ROLLBACK TRAN @ProcName
	RETURN
		@Result
END
IF	@ProcReturn != 0 BEGIN
	SET	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	ROLLBACK TRAN @ProcName
	RETURN
		@Result
END
IF	@ProcResult != 0 BEGIN
	SET	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	ROLLBACK TRAN @ProcName
	RETURN
		@Result
END
--- </Call>
--- </Body>

--- <Troubleshooting>
INSERT
	FT.AuditRAN_shipmentSummary 
(	ShipperID
,	TranDT
,	ShipTo
,   CustomerPart
,   QtyPacked
,   ActiveOrderNo
)
SELECT
	@ShipperID
,	@TranDT
,	ShipTo
,   CustomerPart
,   QtyPacked
,   ActiveOrderNo
FROM
	#shipmentSummary

INSERT
	FT.AuditRAN_requirements
(	ShipperID
,	TranDT
,	RowID
,	ActiveOrderNo
,	ShipTo
,	CustomerPart
,	ReleaseDate
,	ReleaseNo
,	QtyRequired
,	PriorAccum
,	PostAccum
)
SELECT
	@ShipperID
,	@TranDT
,	RowID
,	ActiveOrderNo
,	ShipTo
,	CustomerPart
,	ReleaseDate
,	ReleaseNo
,	QtyRequired
,	PriorAccum
,	PostAccum
FROM
	#requirements

INSERT
	FT.AuditRAN_releasesShipped
(	ShipperID
,	TranDT
,	RowID
,	ActiveOrderNo
,	ShipTo
,	CustomerPart
,	ReleaseDate
,	ReleaseNo
,	ReleaseQty
,	PriorAccum
,	PostAccum
)
SELECT
	@ShipperID
,	@TranDT
,	RowID
,	ActiveOrderNo
,	ShipTo
,	CustomerPart
,	ReleaseDate
,	ReleaseNo
,	ReleaseQty
,	PriorAccum
,	PostAccum
FROM
	#releasesShipped

INSERT
	FT.AuditRAN_releases
(	ShipperID
,	TranDT
,	RowID
,	OrderNo
,	ActiveOrderNo
,	ShipTo
,	CustomerPart
,	ReleaseDate
,	ReleaseNo
,	PartCode
,	QtyRequired
,	PriorAccum
,	PostAccum
,	ReleaseID
,	ReleiveQty
,	DeleteRelease
)
SELECT
	@ShipperID
,	@TranDT
,	RowID
,	OrderNo
,	ActiveOrderNo
,	ShipTo
,	CustomerPart
,	ReleaseDate
,	ReleaseNo
,	PartCode
,	QtyRequired
,	PriorAccum
,	PostAccum
,	ReleaseID
,	ReleiveQty
,	DeleteRelease
FROM
	#releases
--- </Troubleshooting>

IF	@TranCount = 0 BEGIN
	COMMIT TRAN @ProcName
END

---	<Return>
SET	@Result = 0
RETURN
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
	@shipperID int

set	@shipperID = 59088

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_Shipping_ShipoutReleiveOrders
	@ShipperID = @shipperID
,	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Debug = 1

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

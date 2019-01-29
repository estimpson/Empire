SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*
Create procedure FX.dbo.usp_Shipping_GetNALRANs
*/

--use FX
--go

--if	objectproperty(object_id('dbo.usp_Shipping_GetNALRANs'), 'IsProcedure') = 1 begin
--	drop procedure dbo.usp_Shipping_GetNALRANs
--end
--go

--create procedure dbo.usp_Shipping_GetNALRANs
CREATE procedure [dbo].[usp_Shipping_GetNALRANs]
	@ShipperID integer
,	@OrderNo numeric(8,0)
,	@Debug integer = 1
as
set nocount on
set ansi_warnings off

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

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
/*	Record Audit data for all key decision data used in this process. */
declare
	@TranDT datetime = getdate()
/* ASB FT, LLC 01/29/2019 : Commenting for now until Eric can optimize query performance. Begin Comment ASB
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
,	AuditSource = 'Packing Slip'
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
,	AuditSource = 'Packing Slip'
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
,	AuditSource = 'Packing Slip'
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
,	AuditSource = 'Packing Slip'
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
,	AuditSource = 'Packing Slip'
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
,	AuditSource = 'Packing Slip'
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
	
	END COMMENT ASB*/

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
,	QtyPacked = sum(sd.qty_required)
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
		#shipmentSummary.ShipTo
	,   #shipmentSummary.CustomerPart
	,   #shipmentSummary.QtyPacked
	,   #shipmentSummary.ActiveOrderNo
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
select
	ActiveOrderNo = ss.ActiveOrderNo
,	ShipTo = od.destination
,	CustomerPart = od.customer_part
,	ReleaseDate = od.due_date
,	ReleaseNo = coalesce(od.release_no, '')
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
,	od.release_no
order by
	od.destination
,	od.customer_part
,	od.due_date
,	od.release_no

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
--- </Body>

--- <Troubleshooting>
insert
	FT.AuditRAN_shipmentSummary 
(	ShipperID
,	TranDT
,	ShipTo
,   CustomerPart
,   QtyPacked
,   ActiveOrderNo
)
select
	@ShipperID
,	@TranDT
,	ShipTo
,   CustomerPart
,   QtyPacked
,   ActiveOrderNo
from
	#shipmentSummary

insert
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
select
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
from
	#requirements

insert
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
select
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
from
	#releasesShipped

insert
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
select
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
from
	#releases
--- </Troubleshooting>

---	<Return>
/*	Get RANs for the current order. */
select
	RanNumber = rs.ReleaseNo
,	Qty =
		case
			when r.PostAccum < rs.PriorAccum then 0
			when r.PriorAccum > rs.PostAccum then 0
			when r.PostAccum >= rs.PostAccum and r.PriorAccum <= rs.PriorAccum then rs.PostAccum - rs.PriorAccum
			when r.PostAccum < rs.PostAccum and r.PriorAccum > rs.PriorAccum then r.PostAccum - r.PriorAccum
			when r.PostAccum >= rs.PostAccum and r.PriorAccum > rs.PriorAccum then rs.PostAccum - r.PriorAccum
			when r.PostAccum < rs.PostAccum and r.PriorAccum <= rs.PriorAccum then r.PostAccum - rs.PriorAccum
		end
from
	#releases r
	join #releasesShipped rs
		on rs.ActiveOrderNo = r.ActiveOrderNo
		and rs.ReleaseDate = r.ReleaseDate
where
	r.PostAccum > rs.PriorAccum
	and r.PriorAccum < rs.PostAccum
	and r.OrderNo = @OrderNo

return
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
,	@orderNo numeric(8,0)

set	@shipperID = 59290
set	@orderNo = 14603

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_Shipping_GetNALRANs
	@ShipperID = @shipperID
,	@OrderNo = @orderNo
,	@Debug = 0

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

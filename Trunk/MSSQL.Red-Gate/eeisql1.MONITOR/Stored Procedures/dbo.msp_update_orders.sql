SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[msp_update_orders](
	@shipper integer )
as
---------------------------------------------------------------------------------------
--	This procedure updates orders based on shipped line items.
--
--	Modifications:	01 MAR 1999, Harish P. Gubbi	Original.
--			02 JUL 1999, Harish P. Gubbi	Updating releases for normal orders.
--			03 JUL 1999, Harish P. Gubbi	Re-sequencing for normal orders.
--			07 JUL 1999, Eric E. Stimpson	Reformatted.
--			04 AUG 1999, Eric E. Stimpson	Removed loop through blanket order releases.
--			03 SEP 1999, Eric E. Stimpson	Removed references to @accumshipped from blanket order processing.
--			21 FEB 2001, Harish G. P	Changed the column to get the right std qty for normal orders	
--			31 MAR 2001, Harish G. P	Changed the column to from pack_line_qty to qty_packed for normal orders	
--			06 MAR 2002, Harish G. P	Included a new variable to store od.quantity & use the same in the equation
--							 to calculate new shipqty
--			10 FEB 2003, Harish G. P	Included order type check while closing the order
--			04 JAN 2007, Andre S. Boulanger	Updates order_detail.eeiqty when order_detail.quantity is updated.
--			19 JAN 2010, Andre S. Boulanger	Inserts [NALRanNumbersShipped] for Rans Shipped.
--			05 FEB 2010, Andre S. Boulanger	See 2a in process section
--			11 FEB 2011, Andre S. Boulanger Eliminates Mitsubishi part MIT0005 from spreading of Accum shipped across all sales orders.
--			07 MAR 2011, Andre S. Boulanger Inserts [AutoLivRanNumbersShipped] for Rans Shipped
--			12 NOV 2013, Andre S. Boulanger Commented RAN table inserts for both AutoLiv and NAL. Process is now handled by usp_Shipping_ShipoutReleiveOrders
--
--	Parameters:	@shipper
--			@operator
--			@returnvalue
--
--	Returns:	  0	success
--
--	Process:
--	1.	Declare all the required local variables.
--	2a.	Get Active Revison Sales Orders For orders being shipped that are not active orders and update order_header.our_cum for active order
--	2b.	Update accum shipped on shipper detail and blanket order header.
--	3.	Remove mps records and releases for fully shipped releases.
--	4.	Remove mps records and mark releases for partially shipped releases.
--	5.	Declare cursor for lineitems shipped against normal orders.
--	6.	Loop through lineitems.
--	7.	Declare cursor for releases.
--	8.	Loop through all releases for this part and suffix in due_date order.
--	9.	Check if release was fully shipped.
--	10.	Remove mps records and releases for fully shipped release.
--	11.	Remove mps records and mark releases for partially shipped release.
--	12.	Get next release.
--	13.	Get next lineitem.
--	14.	Declare cursor for shipped orders.
--	15.	Loop through orders.
--	16.	Check order for remaining releases.
--	17.	Resequence remaining releases.
--	18.	Initialize new sequence.
--	19.	Mark remaining releases to process.
--	20.	Declare cursor for remainingreleases.
--	21.	Loop through all remaining releases.
--	22.	Set new sequence.
--	23.	Get next remaining release.
--	24.	Get next shipped order.
--	25.	Return.
---------------------------------------------------------------------------------------

--	1.	Declare all the required local variables.
declare
	@part		varchar(25),
	@orderno	numeric(8,0),
	@stdqty		numeric(20,6),
	@suffix		integer,
	@ordertype	char(1),
	@ourcum		numeric(20,6),
	@accumshipped	numeric(20,6),
	@sequence	numeric(5,0),
	@relstdqty	numeric(20,6),
	@shipqty	numeric(20,6),	
	@releasedt	datetime,
	@releaseno	varchar(20),
	@rowid		integer,
	@newsequence	integer,
	@odqty		numeric(20,6)
	
--	2a. Get Active Revison Sales Orders For orders being shipped that are not active orders and update order_header.our_cum for active order
execute ftsp_RecalcReleaseAccums_forShipper
	@ShipperID = @shipper

--	2b.	Update accum shipped on shipper detail and blanket order header.
--Move to after update of order_header.our_cum Andre S. Boulanger 2012-08-07
/*update	shipper_detail
set		accum_shipped = order_header.our_cum + shipper_detail.alternative_qty
from	shipper_detail
	join shipper on shipper_detail.shipper = shipper.id
	join order_header on shipper_detail.order_no = order_header.order_no
where	shipper_detail.shipper = @shipper and
	order_header.order_type = 'B'
*/
	
update	order_header
set	our_cum = order_header.our_cum + shipper_detail.alternative_qty
from	shipper_detail
	join shipper on shipper_detail.shipper = shipper.id
	join order_header on shipper_detail.order_no = order_header.order_no
where	shipper_detail.shipper = @shipper and
		shipper_detail.part_original like 'MIT0005%' and
		order_header.order_type = 'B'

declare @ActiveRevOrders table
(	CustomerPart varchar(35),
	ShipToID varchar(20),
	QtyShipped numeric(20,6))

insert
	@ActiveRevOrders
(	CustomerPart,
	ShipToID,
	QtyShipped)
select
	oh.customer_part,
	oh.destination,
	sum(sd.alternative_qty)
from
	dbo.order_header oh
	join dbo.shipper_detail sd on
		sd.shipper = @shipper
	and
		oh.order_no = sd.order_no
where
	oh.order_type = 'B' and part_original not like 'MIT0005%'
group by
	oh.customer_part,
	oh.destination
		
update
	dbo.order_header
set
	our_cum = oh.our_cum + aro.QtyShipped
from
	dbo.order_header oh
	join @ActiveRevOrders aro on
		oh.destination = aro.ShipToID
	and
		oh.customer_part = aro.CustomerPart
where
	oh.order_type = 'B'

update
	dbo.order_header
set
	our_cum = 
	(	select
			MAX(our_cum)
		from
			dbo.order_header
		where
			destination = oh.destination
		and
			customer_part = oh.customer_part
		and
			order_type = 'B'
		and
			status = 'A')
from
	dbo.order_header oh
	join @ActiveRevOrders aro on
		oh.destination = aro.ShipToID
	and
		oh.customer_part = aro.CustomerPart
where
	oh.order_type = 'B'
and
	coalesce(oh.status, 'O') != 'A'
and
	exists
	(	select
			*
		from
			dbo.order_header
		where
			destination = oh.destination
		and
			customer_part = oh.customer_part
		and
			order_type = 'B'
		and
			status = 'A')
--Moved Here from 2b. above. Andre S. Boulanger 2012-08-07. Commented out shipper_detail.alternative_qty because this was already applied above
update	shipper_detail
set		accum_shipped = order_header.our_cum /*+ shipper_detail.alternative_qty*/
from	shipper_detail
	join shipper on shipper_detail.shipper = shipper.id
	join order_header on shipper_detail.order_no = order_header.order_no
where	shipper_detail.shipper = @shipper and
	order_header.order_type = 'B'

--	3.	Remove mps records and releases for fully shipped releases.
delete	master_prod_sched
from	master_prod_sched
	join order_detail on origin = order_detail.order_no and
		source = order_detail.row_id
	join order_header on order_detail.order_no = order_header.order_no
	join shipper_detail on shipper_detail.order_no = order_header.order_no
	join shipper on shipper_detail.shipper = shipper.id
where	shipper_detail.shipper = @shipper and
	order_header.order_type = 'B' and
	order_detail.the_cum <= order_header.our_cum

/* Commented 11-12-13 AB : Rans (NAL and AutoLiv) are written by SP usp_Shipping_ShipoutReleiveOrders
INSERT dbo.NALRanNumbersShipped
       ( OrderNo ,
          ShipDate ,
          Qty ,
          RanNumber ,
          Shipper
        )

SELECT  dbo.order_detail.order_no,
		order_detail.due_date,
		dbo.order_detail.quantity,
		dbo.order_detail.release_no,
		@shipper
from	order_detail
	join order_header on order_detail.order_no = order_header.order_no
	join shipper_detail on shipper_detail.order_no = order_header.order_no
	join shipper on shipper_detail.shipper = shipper.id
where	shipper_detail.shipper = @shipper and
	order_header.order_type = 'B' and
	order_detail.the_cum <= order_header.our_cum AND
	order_detail.part_number LIKE 'NAL%'	/*AND
	LEN(dbo.order_detail.release_no)>15*/
	
INSERT dbo.AutoLivRanNumbersShipped
        ( OrderNo ,
          ShipDate ,
          Qty ,
          RanNumber ,
          Shipper
        )

SELECT  dbo.order_detail.order_no,
		order_detail.due_date,
		dbo.order_detail.quantity,
		(CASE WHEN dbo.order_detail.release_no LIKE '%*%' THEN SUBSTRING(dbo.order_detail.release_no, 1, Patindex('%*%', dbo.order_detail.release_no)-1 ) ELSE dbo.order_detail.release_no END),
		@shipper
from	order_detail
	join order_header on order_detail.order_no = order_header.order_no
	join shipper_detail on shipper_detail.order_no = order_header.order_no
	join shipper on shipper_detail.shipper = shipper.id
where	shipper_detail.shipper = @shipper and
	order_header.order_type = 'B' and
	order_detail.the_cum <= order_header.our_cum AND
	order_detail.part_number LIKE 'ALI%'	AND
	dbo.order_detail.release_no LIKE '%*862'
*/

delete	order_detail
from	order_detail
	join order_header on order_detail.order_no = order_header.order_no
	join shipper_detail on shipper_detail.order_no = order_header.order_no
	join shipper on shipper_detail.shipper = shipper.id
where	shipper_detail.shipper = @shipper and
	order_header.order_type = 'B' and
	order_detail.the_cum <= order_header.our_cum

--	4.	Remove mps records and mark releases for partially shipped releases.
delete	master_prod_sched
from	master_prod_sched
	join order_detail on origin = order_detail.order_no and
		source = order_detail.row_id
	join order_header on order_detail.order_no = order_header.order_no
	join shipper_detail on shipper_detail.order_no = order_header.order_no
	join shipper on shipper_detail.shipper = shipper.id
where	shipper_detail.shipper = @shipper and
	order_header.order_type = 'B' and
	order_detail.our_cum < order_header.our_cum and
	order_detail.the_cum > order_header.our_cum
	
/* Commented 11-12-13 AB : Rans Inserted by usp_Shipping_ShipoutReleiveOrders	
INSERT dbo.NALRanNumbersShipped
       ( OrderNo ,
          ShipDate ,
          Qty ,
          RanNumber ,
          Shipper
        )

SELECT  dbo.order_detail.order_no,
		order_detail.due_date,
		order_detail.quantity+(order_header.our_cum-order_detail.the_cum) ,
		dbo.order_detail.release_no,
		@shipper
from	order_detail
	join order_header on order_detail.order_no = order_header.order_no
	join shipper_detail on shipper_detail.order_no = order_header.order_no
	join shipper on shipper_detail.shipper = shipper.id
where	shipper_detail.shipper = @shipper and
	order_header.order_type = 'B' and
	order_detail.our_cum < order_header.our_cum and
	order_detail.the_cum > order_header.our_cum AND
	order_detail.part_number LIKE 'NAL%'	/*AND
	LEN(dbo.order_detail.release_no)>15*/
*/

update	order_detail
set	eeiqty=(eeiqty-order_detail.quantity)+(order_detail.the_cum-order_header.our_cum),	
	std_qty = order_detail.the_cum - order_header.our_cum,
	quantity = order_detail.the_cum - order_header.our_cum,
	our_cum = order_header.our_cum,
	flag=1
from	order_detail
	join order_header on order_detail.order_no = order_header.order_no
	join shipper_detail on shipper_detail.order_no = order_header.order_no
	join shipper on shipper_detail.shipper = shipper.id
where	shipper_detail.shipper = @shipper and
	order_header.order_type = 'B' and
	order_detail.our_cum < order_header.our_cum and
	order_detail.the_cum > order_header.our_cum

--	5.	Declare cursor for lineitems shipped against normal orders.
declare lineitems cursor for
	select	shipper_detail.part_original,
		shipper_detail.order_no,
		shipper_detail.qty_packed,
		shipper_detail.suffix,
		order_header.order_type,
		order_header.our_cum,
		shipper_detail.alternative_qty
	from	shipper_detail
		join shipper on shipper_detail.shipper = shipper.id
		join order_header on shipper_detail.order_no = order_header.order_no
	where	shipper_detail.shipper = @shipper and
		shipper.type is null and
		order_header.order_type = 'N'

--	6.	Loop through lineitems.
open lineitems

fetch	lineitems
into	@part,
	@orderno,
	@stdqty,
	@suffix,
	@ordertype,
	@ourcum,
	@shipqty

while( @@fetch_status = 0 )
begin --(1aB)

--	7.	Declare cursor for releases.
	declare releases insensitive cursor for
	select	sequence,
		std_qty,
		row_id,
		quantity
	from	order_detail
	where	order_no = @orderno and
		part_number = @part and
		IsNull( suffix, 0 ) = IsNull( @suffix, 0 )
	order by due_date

--	8.	Loop through all releases for this part and suffix in due_date order.
	open releases

	fetch	releases
	into	@sequence,
		@relstdqty,
		@rowid,
		@odqty

	while( @@fetch_status = 0 and @stdqty > 0 )
	begin --(2aB)

--	9.	Check if release was fully shipped.

		if @relstdqty <= @stdqty
		begin --(3aB)

--	10.	Remove mps records and releases for fully shipped release.

			delete	master_prod_sched
			from	master_prod_sched
			where	origin = @orderno and
				source = @rowid
			
			delete	order_detail
			where	order_no = @orderno and
				sequence = @sequence

			select	@stdqty = @stdqty - @relstdqty,
				@shipqty = @shipqty - @odqty
		end --(3aB)
		else
		begin --(3bB)
--	11.	Remove mps records and mark releases for partially shipped release.

			delete	master_prod_sched
			from	master_prod_sched
			where	origin = @orderno and
				source = @rowid

			update	order_detail
			set	std_qty = @relstdqty - @stdqty,
				quantity = order_detail.quantity - @shipqty
			where	order_no = @orderno and
				sequence = @sequence

			select	@stdqty = 0
		end --(3bB)

--	12.	Get next release.

		fetch	releases
		into	@sequence,
			@relstdqty,
			@rowid,
			@odqty
	end --(2aB)
	close releases
	deallocate releases
	
--	13.	Get next lineitem.

	fetch	lineitems
	into	@part,
		@orderno,
		@stdqty,
		@suffix,
		@ordertype,
		@ourcum,
		@shipqty
end --(1aB)
close lineitems
deallocate lineitems

--	14.	Declare cursor for shipped orders.

declare orders cursor for
	select distinct shipper_detail.order_no
	from	shipper_detail
		join shipper on shipper_detail.shipper = shipper.id
		join order_header on shipper_detail.order_no = order_header.order_no
	where	shipper_detail.shipper = @shipper and
		shipper.type is null

--	15.	Loop through orders.

open orders

fetch	orders
into	@orderno

while( @@fetch_status = 0 )
begin --(1bB)

--	16.	Check order for remaining releases.

	if not exists(
		select	sequence
		from	order_detail
		where	order_no = @orderno )
		update	order_header
		set	status='C'
		where	order_no = @orderno and isnull(order_type,'B') = 'N'
	
	else
--	17.	Resequence remaining releases.

	begin --(2bB)

--	18.	Initialize new sequence.

		select	@newsequence = 0

--	19.	Mark remaining releases to process.

		update	order_detail
		set	sequence = - sequence
		where	order_no = @orderno

--	20.	Declare cursor for remainingreleases.

		declare remainingreleases insensitive cursor for
			select	sequence
			from	order_detail
			where	order_no = @orderno
			order by part_number,
				due_date

--	21.	Loop through all remaining releases.

		open remainingreleases

		fetch	remainingreleases
		into	@sequence
		
		while( @@fetch_status = 0 )
		begin --(3cB)

--	22.	Set new sequence.

			select	@newsequence = @newsequence + 1
			
			update	order_detail
			set	sequence = @newsequence
			where	order_no = @orderno and
				sequence = @sequence

--	23.	Get next remaining release.

			fetch	remainingreleases
			into	@sequence
		end --(3cB)
		close remainingreleases
		deallocate remainingreleases
	end --(2bB)

--	24.	Recalculate committed quantity.
	execute msp_calculate_committed_qty @orderno

--	24.	Get next shipped order.

	fetch	orders
	into	@orderno

end --(1bB)
close orders
deallocate orders

--	25.	Return.
return 0








GO

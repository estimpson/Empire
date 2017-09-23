SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[msp_transferinsertedrelease] (
	@orderno	numeric (8) )
as
-------------------------------------------------------------------------------------
--	This procedure transfers inserted releases to order detail.
--
--	Modifications:	08 JAN 1999, Eric E. Stimpson	Original
--			25 MAY 1999, Eric E. Stimpson	Modified formatting.
--			01 OCT 1999, Eric E. Stimpson	Modified to consider current accum shipped (#2).
--
--	Paramters:	@orderno	mandatory
--
--	Returns:	  0	success
--			100	order not found
--
--	Process:
--	1.	Delete existing releases.
--	2.	Adjust releases with current accum shipped.
--	3.	Insert new releases.
--	4.	Return success.
---------------------------------------------------------------------------------------

--	1.	Delete existing releases.
delete	order_detail
 where	order_no = @orderno

--	2.	Adjust releases with current accum shipped.
update	order_detail_inserted
set	our_cum = our_cum + (
	select	Max ( order_header.our_cum - odi.our_cum )
	from	order_detail_inserted odi
		join order_header on order_header.order_no = @orderno
	where	odi.order_no = @orderno and
		odi.type = order_detail_inserted.type ),
	the_cum = the_cum + (
	select	Max ( order_header.our_cum - odi.our_cum )
	from	order_detail_inserted odi
		join order_header on order_header.order_no = @orderno
	where	odi.order_no = @orderno and
		odi.type = order_detail_inserted.type )
from	order_detail_inserted
where	order_detail_inserted.order_no = @orderno

--	3.	Insert new releases.
insert	order_detail ( order_no,sequence,part_number,type,product_name,quantity,price,notes,assigned,shipped,invoiced,status,our_cum,the_cum,due_date,destination,unit,committed_qty,row_id,group_no,cost,plant,release_no,flag,week_no,std_qty,customer_part,ship_type,dropship_po,dropship_po_row_id,suffix,packline_qty,packaging_type,weight,custom01,custom02,custom03,dimension_qty_string,engineering_level,box_label,pallet_label,alternate_price) 
select	order_no,sequence,part_number,type,product_name,quantity,price,notes,assigned,shipped,invoiced,status,our_cum,the_cum,due_date,destination,unit,committed_qty,row_id,group_no,cost,plant,release_no,flag,week_no,std_qty,customer_part,ship_type,dropship_po,dropship_po_row_id,suffix,packline_qty,packaging_type,weight,custom01,custom02,custom03,dimension_qty_string,engineering_level,box_label,pallet_label,alternate_price
  from	order_detail_inserted
 where	order_no = @orderno

--	4.	Return success.
return 0
GO

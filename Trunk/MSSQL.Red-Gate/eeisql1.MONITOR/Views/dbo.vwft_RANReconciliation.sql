SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	view [dbo].[vwft_RANReconciliation]
as
select	Order_no, 
			release_no as RanNumber, 
			customer_part,
			part_number,
			destination, 
			due_date,
			quantity as CurrentOrderQty, 
			(select sum(qty) from dbo.NALRanNumbersShipped where RanNumber = od.release_no ) as ShippedRANQty,
			(select max(date_shipped) from shipper_detail where order_no = od.order_no) as LastShippedDT
from		order_detail od
where exists (select 1 from dbo.NALRanNumbersShipped where RanNumber = release_no)
GO

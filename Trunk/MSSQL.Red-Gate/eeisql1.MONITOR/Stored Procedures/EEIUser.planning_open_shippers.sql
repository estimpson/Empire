SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [EEIUser].[planning_open_shippers]

as
select  s.id,
		s.date_stamp,
		release_date,
		s.status,
		ship_via,
		s.customer,
		s.destination,
		sd.part,
		customer_part,
		qty_original,		
		qty_required,
		qty_packed,
		boxes_staged,
		order_no,
		customer_po,
		release_no,
		notes,
		(select sum(quantity) from object where plant = 'EEI' and part = sd.part) as IN_EEI_Warehouse,
		(select sum(quantity) from object where plant = 'TRAN-EEI' and part = sd.part) as IN_TRAN_Location
from	shipper s join shipper_detail sd on s.id = sd.shipper 
where s.status in ('O','S') and isnull(s.type,'x') not in ('R','C') 
order by release_date, customer, id










GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [EEIUser].[acctg_scheduling_view_862d] @ShipToCode varchar(20), @CustomerPart varchar(30)

-- exec eeiuser.acctg_scheduling_view_862d 'ALABAMA', '938 714-13' 

as

--declare @ReleaseCreatedDT datetime
--select @ReleaseCreatedDT = '2/25/2013 9:41:55 AM'
--select @releasecreateddt

declare @a table (	order_no numeric(8,0), plant varchar(10), customer varchar(10), destination varchar(25), ShipToCode varchar(25), notes varchar(510),
					part_number varchar(25), CustomerPart varchar(30), customer_po varchar(20), release_no varchar(30), type varchar(1), due_date datetime, 
				    quantity decimal(20,6), committed_qty decimal(20,6), standard_pack  decimal(20,6), exceptions varchar(50), last_shipper int
				 )
insert into @a
select	
		od.order_no,
		od.plant,
		oh.customer,
		od.destination,
			(case when oh.destination = 'NALMSHOALS' then 'ALABAMA' else
			(case when oh.destination = 'ES3NORTHAL' then 'ALABAMA' else
			(case when oh.destination = 'ES3NALFLORA' then 'FLORA' else
			(case when oh.destination = 'ES3EEIFLORA' then 'FLORA' else
			(case when oh.destination = 'NALPARIS' then 'PARIS' else
			(case when oh.destination = 'ES3NALPARIS' then 'PARIS' else
			(case when oh.destination = 'ES3EEIPARIS' then 'PARIS' else
			(case when oh.destination = 'NALSALEM' then 'SALEM' else
			(case when oh.destination = 'ES3NALSALEM' then 'SALEM' else
			(case when oh.destination = 'EEANALSALEM' then 'SALEM' else
			oh.destination end)end)end)end)end)end)end)end)end)end) as ShipToCode,		
	    isnull(oh.notes,'')+isnull(od.notes,'') as notes,
		od.part_number,		
		od.customer_part as CustomerPart,
		oh.customer_po,
		od.release_no,
		od.type,
		od.due_date,
		od.quantity,
		od.committed_qty,
		oh.standard_pack,
		(case when standard_pack < 1 then 'Standard Pack Not Defined!' else (case when od.quantity/standard_pack = 1 then 'Non-Standard Pack Order!' else '' end)end),
		oh.shipper as last_shipped	

from order_header oh join order_detail od on oh.order_no = od.order_no 
where oh.customer like '%NAL%' 

select * from @a where ShipToCode = @ShipToCode and CustomerPart = @CustomerPart order by order_no, CustomerPart, due_date


GO

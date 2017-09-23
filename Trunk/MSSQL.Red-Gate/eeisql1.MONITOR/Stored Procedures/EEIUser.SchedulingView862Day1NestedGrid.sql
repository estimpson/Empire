SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EEIUser].[SchedulingView862Day1NestedGrid] @Day1ReleaseNo varchar(30)

-- exec eeiuser.SchedulingView862Day1NestedGrid 'KR00000082450626'

as


--1. Retreive the most recent shipments (only includes shipped status)

select		s.id, s.status, s.date_shipped, s.bill_of_lading_number, s.customer, s.destination, 
			(case when s.destination = 'NALMSHOALS' then 'ALABAMA' else
			(case when s.destination = 'ES3NORTHAL' then 'ALABAMA' else
			(case when s.destination = 'ES3NALFLORA' then 'FLORA' else
			(case when s.destination = 'ES3EEIFLORA' then 'FLORA' else
			(case when s.destination = 'NALPARIS' then 'PARIS' else
			(case when s.destination = 'ES3NALPARIS' then 'PARIS' else
			(case when s.destination = 'ES3EEIPARIS' then 'PARIS' else
			(case when s.destination = 'NALSALEM' then 'SALEM' else
			(case when s.destination = 'ES3NALSALEM' then 'SALEM' else
			(case when s.destination = 'EEANALSALEM' then 'SALEM' else
			s.destination end)end)end)end)end)end)end)end)end)end),
			s.plant, sd.qty_required, sd.qty_packed, sd.boxes_staged, sd.order_no, sd.customer_po, 
			sd.release_no, sd.part_original, sd.customer_part, ran.qty, ran.rannumber as Day1ReleaseNo
from	NALRANNUMBERSShipped ran join shipper s on ran.Shipper = s.id join shipper_detail sd on ran.shipper = sd.shipper and ran.OrderNo = sd.order_no 
where	ran.RanNumber = @Day1ReleaseNo
order by s.date_shipped

GO

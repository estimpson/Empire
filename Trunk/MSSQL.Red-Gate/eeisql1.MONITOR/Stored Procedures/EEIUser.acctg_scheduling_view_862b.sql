SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [EEIUser].[acctg_scheduling_view_862b] @releasecreatedDT datetime, @ShipToCode varchar(20), @CustomerPart varchar(30)

-- exec eeiuser.acctg_scheduling_view_862b '2/25/2013 9:41:55 AM', 'ALABAMA', '938 714-13' 

as

--declare @ReleaseCreatedDT datetime
--select @ReleaseCreatedDT = '2/25/2013 9:41:55 AM'
--select @releasecreateddt

declare @a table (	id int, status varchar(1), date_shipped datetime, bill_of_lading_number int, customer varchar(25), destination varchar(20), ShipToCode varchar(20),
					plant varchar(10), qty_required numeric(20,6), qty_packed numeric(20,6), boxes_staged int, order_no numeric(8,0), customer_po varchar(25), 
					release_no varchar(30), part_original varchar(25), CustomerPart varchar(30), qty numeric(20,6), rannumber varchar(50)
				 )


insert into @a 
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
			sd.release_no, sd.part_original, sd.customer_part, ran.qty, ran.rannumber
from	shipper s join shipper_detail sd on s.id = sd.shipper left join NALRanNumbersShipped ran on sd.order_no = ran.OrderNo and sd.shipper = ran.Shipper
where	customer like '%NAL%' 
	and s.date_shipped >= dateadd(d,-5,@ReleaseCreatedDT) 
	and s.date_shipped < DATEADD(d,7,@ReleaseCreatedDT)

select plant, ShipToCode, CustomerPart, part_original, release_no as shipper_ran, rannumber as nal_ran, qty, qty_required, qty_packed, id, status, date_shipped from @a 
where ShipToCode = @ShipToCode and CustomerPart = @CustomerPart
order by destination, id, release_no




--declare @day1 datetime
--		,@day2 datetime
--		,@day3 datetime
--		,@day4 datetime
--		,@day5 datetime
--		,@day6 datetime
--select @day1 = DATEADD(d,1,@latestran)
--		,@day2 = DATEADD(d,2,@latestran)
--		,@day3 = DATEADD(d,3,@latestran)
--		,@day4 = DATEADD(d,4,@latestran)
--		,@day5 = DATEADD(d,5,@latestran)
--		,@day6 = DATEADD(d,6,@latestran)


--select		 coalesce(aa.shiptocode,bb.shiptocode,cc.shiptocode,dd.shiptocode,ee.shiptocode,ff.shiptocode,gg.shiptocode,hh.shiptocode) AS ShipToCode
--			,coalesce(aa.customerpart, bb.customerpart, cc.customerpart, dd.customerpart, ee.customerpart, ff.customerpart, gg.customerpart, hh.customerpart) AS CustomerPart
--			,coalesce(aa.releaseNO,aa.customerPO) as PastDueReleaseNo
--			,aa.releaseqty AS PastDueReleaseQty
--			,aa.ReleaseDT AS PastDueReleaseDT
--			,coalesce(bb.releaseNO,bb.customerPO) as Day0ReleaseNo
--			,bb.releaseqty AS Day0ReleaseQty
--			,bb.ReleaseDT AS Day0ReleaseDT
--			,coalesce(cc.releaseNO,cc.customerPO) as Day1ReleaseNo
--			,cc.releaseqty AS Day1ReleaseQty
--			,cc.ReleaseDT AS Day1ReleaseDT
--			,coalesce(dd.releaseNO,dd.customerPO) as Day2ReleaseNo
--			,dd.releaseqty AS Day2ReleaseQty
--			,dd.ReleaseDT AS Day2ReleaseDT
--			,coalesce(ee.releaseNO,ee.customerPO) as Day3ReleaseNo
--			,ee.releaseqty AS Day3ReleaseQty
--			,ee.ReleaseDT AS Day3ReleaseDT
--			,coalesce(ff.releaseNO,ff.customerPO) as Day4ReleaseNo
--			,ff.releaseqty AS Day4ReleaseQty
--			,ff.ReleaseDT AS Day4ReleaseDT
--			,coalesce(gg.releaseNO,gg.customerPO) as Day5ReleaseNo
--			,gg.releaseqty AS Day5ReleaseQty
--			,gg.ReleaseDT AS Day5ReleaseDT
--			,coalesce(hh.releaseNO,hh.customerPO) as Day6ReleaseNo
--			,hh.releaseqty AS Day6ReleaseQty
--			,hh.ReleaseDT AS Day6ReleaseDT
	
--			from 

--(select * from @a where releaseDT < @latestran) aa

--full outer join
--(select * from @a where releaseDT = @latestran) bb
--on aa.ShipToCode = bb.ShipToCode and aa.CustomerPart = bb.customerpart

--full outer join
--(select * from @a where releaseDT = @day1) cc
--on coalesce(aa.ShipToCode,bb.ShipToCode) = cc.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart) = cc.customerpart

--full outer join
--(select * from @a where releaseDT = @day2) dd
--on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode) = dd.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart) = dd.customerpart

--full outer join
--(select * from @a where releaseDT = @day3) ee
--on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode,dd.ShipToCode) = ee.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart,dd.CustomerPart) = ee.customerpart

--full outer join
--(select * from @a where releaseDT = @day4) ff
--on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode,dd.ShipToCode,ee.ShipToCode) = ff.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart,dd.CustomerPart,ee.CustomerPart) = ff.customerpart

--full outer join
--(select * from @a where releaseDT = @day5) gg
--on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode,dd.ShipToCode,ee.ShipToCode,ff.ShipToCode) = gg.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart,dd.CustomerPart,ee.CustomerPart, ff.CustomerPart) = gg.customerpart

--full outer join
--(select * from @a where releaseDT = @day6) hh
--on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode,dd.ShipToCode,ee.ShipToCode,ff.ShipToCode,gg.ShipToCode) = hh.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart,dd.CustomerPart,ee.CustomerPart, ff.CustomerPart, gg.CustomerPart) = hh.customerpart

--order by ShipToCode, customerpart








GO

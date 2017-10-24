SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_scheduling_view_862] @releasecreatedDT datetime

-- exec eeiuser.acctg_scheduling_view_862 '2/25/2013 9:41:55 AM' 

as

--declare @releasecreateddt datetime
--select @releasecreatedDT = '2/25/2013 10:38 AM'
--select @releasecreateddt

declare @a table (shipToCode varchar(15), CustomerPart varchar(35), BasePart varchar(7), CustomerPO varchar(35), ShipFromCode varchar(15), releaseno varchar(30), releaseqty int, releaseDT datetime, rowcreatedt datetime)

insert into @a 
select ShipToCode, CustomerPart, BasePart, CustomerPO, e.default_distribution_point, ReleaseNo, ReleaseQty, ReleaseDT, rowcreateDT 
from edi.NAL_862_Releases 
left join eeiuser.customer_parts e on edi.NAL_862_releases.CustomerPart = e.customer_part
left join 
(select distinct(left(part,7)) as basepart, cross_ref from part)d on edi.NAL_862_Releases.CustomerPart = d.cross_ref

where  ft.fn_truncdate('S',rowcreatedt) = @releasecreatedDT

--select * from @a

declare @latestran datetime
select @latestran = ft.fn_truncdate('d', (select min(rowcreatedt) from @a))

declare @day1 datetime
		,@day2 datetime
		,@day3 datetime
		,@day4 datetime
		,@day5 datetime
		,@day6 datetime
select @day1 = DATEADD(d,1,@latestran)
		,@day2 = DATEADD(d,2,@latestran)
		,@day3 = DATEADD(d,3,@latestran)
		,@day4 = DATEADD(d,4,@latestran)
		,@day5 = DATEADD(d,5,@latestran)
		,@day6 = DATEADD(d,6,@latestran)


select		 coalesce(aa.shipfromcode,bb.shipfromcode,cc.shipfromcode,dd.shipfromcode,ee.shipfromcode,ff.shipfromcode,gg.shipfromcode,hh.shipfromcode) AS ShipFromCode 
			,coalesce(aa.shiptocode,bb.shiptocode,cc.shiptocode,dd.shiptocode,ee.shiptocode,ff.shiptocode,gg.shiptocode,hh.shiptocode) AS ShipToCode
			,coalesce(aa.customerpart, bb.customerpart, cc.customerpart, dd.customerpart, ee.customerpart, ff.customerpart, gg.customerpart, hh.customerpart) AS CustomerPart
			,coalesce(aa.basepart, bb.basepart, cc.basepart, dd.basepart, ee.basepart, ff.basepart, gg.basepart, hh.basepart) AS BasePart
			,coalesce(aa.releaseNO,aa.customerPO) as PastDueReleaseNo
			,aa.releaseqty AS PastDueReleaseQty
			,aa.ReleaseDT AS PastDueReleaseDT
			,coalesce(bb.releaseNO,bb.customerPO) as Day0ReleaseNo
			,bb.releaseqty AS Day0ReleaseQty
			,bb.ReleaseDT AS Day0ReleaseDT
			,coalesce(cc.releaseNO,cc.customerPO) as Day1ReleaseNo
			,cc.releaseqty AS Day1ReleaseQty
			,cc.ReleaseDT AS Day1ReleaseDT
			,coalesce(dd.releaseNO,dd.customerPO) as Day2ReleaseNo
			,dd.releaseqty AS Day2ReleaseQty
			,dd.ReleaseDT AS Day2ReleaseDT
			,coalesce(ee.releaseNO,ee.customerPO) as Day3ReleaseNo
			,ee.releaseqty AS Day3ReleaseQty
			,ee.ReleaseDT AS Day3ReleaseDT
			,coalesce(ff.releaseNO,ff.customerPO) as Day4ReleaseNo
			,ff.releaseqty AS Day4ReleaseQty
			,ff.ReleaseDT AS Day4ReleaseDT
			,coalesce(gg.releaseNO,gg.customerPO) as Day5ReleaseNo
			,gg.releaseqty AS Day5ReleaseQty
			,gg.ReleaseDT AS Day5ReleaseDT
			,coalesce(hh.releaseNO,hh.customerPO) as Day6ReleaseNo
			,hh.releaseqty AS Day6ReleaseQty
			,hh.ReleaseDT AS Day6ReleaseDT
			,@latestran as day0
			,@day1 as day1
			,@day2 as day2
			,@day3 as day3
			,@day4 as day4
			,@day5 as day5
			,@day6 as day6
		
			from 

(select * from @a where releaseDT < @latestran) aa

full outer join
(select * from @a where releaseDT = @latestran) bb
on aa.ShipToCode = bb.ShipToCode and aa.CustomerPart = bb.customerpart

full outer join
(select * from @a where releaseDT = @day1) cc
on coalesce(aa.ShipToCode,bb.ShipToCode) = cc.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart) = cc.customerpart

full outer join
(select * from @a where releaseDT = @day2) dd
on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode) = dd.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart) = dd.customerpart

full outer join
(select * from @a where releaseDT = @day3) ee
on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode,dd.ShipToCode) = ee.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart,dd.CustomerPart) = ee.customerpart

full outer join
(select * from @a where releaseDT = @day4) ff
on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode,dd.ShipToCode,ee.ShipToCode) = ff.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart,dd.CustomerPart,ee.CustomerPart) = ff.customerpart

full outer join
(select * from @a where releaseDT = @day5) gg
on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode,dd.ShipToCode,ee.ShipToCode,ff.ShipToCode) = gg.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart,dd.CustomerPart,ee.CustomerPart, ff.CustomerPart) = gg.customerpart

full outer join
(select * from @a where releaseDT = @day6) hh
on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode,dd.ShipToCode,ee.ShipToCode,ff.ShipToCode,gg.ShipToCode) = hh.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart,dd.CustomerPart,ee.CustomerPart, ff.CustomerPart, gg.CustomerPart) = hh.customerpart

order by ShipFromCode, ShipToCode, customerpart







GO

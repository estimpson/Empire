SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [EEIUser].[OBS.acctg_scheduling_latestRANnumber] @releasecreatedDT datetime

as

declare @a table (shipToCode varchar(15), CustomerPart varchar(35), CustomerPO varchar(35), ShipFromCode varchar(15), releaseno varchar(30), releaseqty int, releaseDT datetime, rowcreatedt datetime)

insert into @a 
select ShipToCode, CustomerPart, CustomerPO, ShipFromCode, ReleaseNo, ReleaseQty, ReleaseDT, rowcreateDT from edi.NAL_862_Releases
where rowcreatedt = @releasecreatedDT


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


select		 coalesce(aa.shiptocode,bb.shiptocode,cc.shiptocode,dd.shiptocode,ee.shiptocode,ff.shiptocode,gg.shiptocode,hh.shiptocode) AS ShipToCode
			,coalesce(aa.customerpart, bb.customerpart, cc.customerpart, dd.customerpart, ee.customerpart, ff.customerpart, gg.customerpart, hh.customerpart) AS CustomerPart
			,coalesce(aa.releaseNO,aa.customerPO) as PastDueReleases
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
			,coalesce(gg.releaseNO,gg.customerPO) as Day5ReleasNo
			,gg.releaseqty AS Day5Qty
			,gg.ReleaseDT AS Day5ReleaseDT
			,coalesce(hh.releaseNO,hh.customerPO) as Day6ReleaseNo
			,hh.releaseqty AS Day6ReleaseQty
			,hh.ReleaseDT AS Day6ReleaseDT

		
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

order by ShipToCode, customerpart




GO

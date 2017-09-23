SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[OBS.acctg_scheduling_nal_rans_by_week]

as

declare  @startmon date
select	@startmon = '2/18/2013'
declare  @mon date
		,@tue date
		,@wed date
		,@thu date
		,@fri date
		,@sat date
		,@sun date
select	 @mon = (select ft.fn_TruncDate_monday('ww',@startmon))
		,@tue = (case when DATEADD(d,1,ft.fn_TruncDate_monday('ww',@startmon)) > GETDATE() then GETDATE() else DATEADD(d,1,ft.fn_TruncDate_monday('ww',@startmon)) end)
		,@wed = (case when DATEADD(d,2,ft.fn_TruncDate_monday('ww',@startmon)) > GETDATE() then GETDATE() else DATEADD(d,2,ft.fn_TruncDate_monday('ww',@startmon)) end)
		,@thu = (case when DATEADD(d,3,ft.fn_TruncDate_monday('ww',@startmon)) > GETDATE() then GETDATE() else DATEADD(d,3,ft.fn_TruncDate_monday('ww',@startmon)) end)
		,@fri = (case when DATEADD(d,4,ft.fn_TruncDate_monday('ww',@startmon)) > GETDATE() then GETDATE() else DATEADD(d,4,ft.fn_TruncDate_monday('ww',@startmon)) end)
		,@sat = (case when DATEADD(d,5,ft.fn_TruncDate_monday('ww',@startmon)) > GETDATE() then GETDATE() else DATEADD(d,5,ft.fn_TruncDate_monday('ww',@startmon)) end)
		,@sun = (case when DATEADD(d,6,ft.fn_TruncDate_monday('ww',@startmon)) > GETDATE() then GETDATE() else DATEADD(d,6,ft.fn_TruncDate_monday('ww',@startmon)) end)

declare  @mondue date
		,@tuedue date
		,@weddue date
		,@thudue date
		,@fridue date
		,@satdue date
		,@sundue date
select	 @mondue = (select ft.fn_TruncDate_monday('ww',@startmon))
		,@tuedue = (select DATEADD(d,1,ft.fn_TruncDate_monday('ww',@startmon)))
		,@weddue = (select DATEADD(d,2,ft.fn_TruncDate_monday('ww',@startmon)))
		,@thudue = (select DATEADD(d,3,ft.fn_TruncDate_monday('ww',@startmon)))
		,@fridue = (select DATEADD(d,4,ft.fn_TruncDate_monday('ww',@startmon)))
		,@satdue = (select DATEADD(d,5,ft.fn_TruncDate_monday('ww',@startmon)))
		,@sundue = (select DATEADD(d,6,ft.fn_TruncDate_monday('ww',@startmon)))	
					

 select		 coalesce(aa.shiptocode,bb.shiptocode,cc.shiptocode,dd.shiptocode,ee.shiptocode,ff.shiptocode,gg.shiptocode) AS ShipToCode
			,coalesce(aa.customerpart, bb.customerpart, cc.customerpart, dd.customerpart, ee.customerpart, ff.customerpart, gg.customerpart) AS CustomerPart
			,coalesce(aa.releaseNO,aa.customerPO) as MonReleaseNo
			,aa.releaseqty AS MonReleaseQty
			,aa.ReleaseDT AS MonReleaseDT
			,coalesce(bb.releaseNO,bb.customerPO) as TueReleaseNo
			,bb.releaseqty AS TueReleaseQty
			,bb.ReleaseDT AS TueReleaseDT
			,coalesce(cc.releaseNO,cc.customerPO) as WedReleaseNo
			,cc.releaseqty AS WedReleaseQty
			,cc.ReleaseDT AS WedReleaseDT
			,coalesce(dd.releaseNO,dd.customerPO) as ThuReleaseNo
			,dd.releaseqty AS ThuReleaseQty
			,dd.ReleaseDT AS ThuReleaseDT
			,coalesce(ee.releaseNO,ee.customerPO) as FriReleaseNo
			,ee.releaseqty AS FriReleaseQty
			,ee.ReleaseDT AS FriReleaseDT
			,coalesce(ff.releaseNO,ff.customerPO) as SatReleaseNo
			,ff.releaseqty AS SatReleaseQty
			,ff.ReleaseDT AS SatReleaseDT
			,coalesce(gg.releaseNO,gg.customerPO) as SunReleaseNo
			,gg.releaseqty AS SunReleaseQty
			,gg.ReleaseDT AS SunReleaseDT
		
			from 

(select ShipToCode, CustomerPart, CustomerPO, ShipFromCode, ReleaseNo, ReleaseQty, ReleaseDT, RowID, RowCreateDT from 
edi.NAL_862_Releases where RowCreateDT = (select MIN(rowcreatedt) from edi.NAL_862_Releases where ft.fn_truncdate('d',RowCreateDt) = @mon group by ft.fn_truncdate('d',RowCreateDT))
and ft.fn_truncdate('d',ReleaseDT) = @mondue) aa

full outer join
(select ShipToCode, CustomerPart, CustomerPO, ShipFromCode, ReleaseNo, ReleaseQty, ReleaseDT, RowID, RowCreateDT from 
edi.NAL_862_Releases where RowCreateDT = (select MIN(rowcreatedt) from edi.NAL_862_Releases where ft.fn_truncdate('d',RowCreateDt) = @tue group by ft.fn_truncdate('d',RowCreateDT))
and ft.fn_truncdate('d',ReleaseDT) = @tuedue) bb
on aa.ShipToCode = bb.ShipToCode and aa.CustomerPart = bb.customerpart

full outer join
(select ShipToCode, CustomerPart, CustomerPO, ShipFromCode, ReleaseNo, ReleaseQty, ReleaseDT, RowID, RowCreateDT from 
edi.NAL_862_Releases where RowCreateDT = (select MIN(rowcreatedt) from edi.NAL_862_Releases where ft.fn_truncdate('d',RowCreateDt) = @wed group by ft.fn_truncdate('d',RowCreateDT))
and ft.fn_truncdate('d',ReleaseDT) = @weddue) cc
on coalesce(aa.ShipToCode,bb.ShipToCode) = cc.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart) = cc.customerpart

full outer join
(select ShipToCode, CustomerPart, CustomerPO, ShipFromCode, ReleaseNo, ReleaseQty, ReleaseDT, RowID, RowCreateDT from 
edi.NAL_862_Releases where RowCreateDT = (select MIN(rowcreatedt) from edi.NAL_862_Releases where ft.fn_truncdate('d',RowCreateDt) = @thu group by ft.fn_truncdate('d',RowCreateDT))
and ft.fn_truncdate('d',ReleaseDT) = @thudue) dd
on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode) = dd.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart) = dd.customerpart

full outer join
(select ShipToCode, CustomerPart, CustomerPO, ShipFromCode, ReleaseNo, ReleaseQty, ReleaseDT, RowID, RowCreateDT from 
edi.NAL_862_Releases where RowCreateDT = (select MIN(rowcreatedt) from edi.NAL_862_Releases where ft.fn_truncdate('d',RowCreateDt) = @fri group by ft.fn_truncdate('d',RowCreateDT))
and ft.fn_truncdate('d',ReleaseDT) = @fridue) ee
on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode,dd.ShipToCode) = ee.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart,dd.CustomerPart) = ee.customerpart

full outer join
(select ShipToCode, CustomerPart, CustomerPO, ShipFromCode, ReleaseNo, ReleaseQty, ReleaseDT, RowID, RowCreateDT from 
edi.NAL_862_Releases where RowCreateDT = (select MIN(rowcreatedt) from edi.NAL_862_Releases where ft.fn_truncdate('d',RowCreateDt) = @sat group by ft.fn_truncdate('d',RowCreateDT))
and ft.fn_truncdate('d',ReleaseDT) = @satdue) ff
on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode,dd.ShipToCode,ee.ShipToCode) = ff.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart,dd.CustomerPart,ee.CustomerPart) = ff.customerpart

full outer join
(select ShipToCode, CustomerPart, CustomerPO, ShipFromCode, ReleaseNo, ReleaseQty, ReleaseDT, RowID, RowCreateDT from 
edi.NAL_862_Releases where RowCreateDT = (select MIN(rowcreatedt) from edi.NAL_862_Releases where ft.fn_truncdate('d',RowCreateDt) = @sun group by ft.fn_truncdate('d',RowCreateDT))
and ft.fn_truncdate('d',ReleaseDT) = @sundue) gg
on coalesce(aa.ShipToCode,bb.ShipToCode,cc.ShipToCode,dd.ShipToCode,ee.ShipToCode,ff.ShipToCode) = gg.ShipToCode and coalesce(aa.CustomerPart,bb.CustomerPart,cc.CustomerPart,dd.CustomerPart,ee.CustomerPart, ff.CustomerPart) = gg.customerpart

order by ShipToCode, customerpart
GO

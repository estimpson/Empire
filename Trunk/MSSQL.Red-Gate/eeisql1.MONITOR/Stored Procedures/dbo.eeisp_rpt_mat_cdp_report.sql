SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create Procedure	[dbo].[eeisp_rpt_mat_cdp_report] (@FromDate datetime, @ThroughDate datetime)

as

begin

--Customer Delivery Performance Report

-- eeisp_rpt_mat_cdp_report '2008-09-01', '2008-09-30'

SELECT	part_eecustom.team_no, 
		shipper.customer, 
		shipper_detail.shipper, 
		shipper_detail.part, 
		shipper_detail.release_date, 
		shipper_detail.date_shipped,
		(CASE WHEN datediff(dd,shipper_detail.release_date, shipper_detail.date_shipped) < =4 and datediff(dd,shipper_detail.release_date, shipper_detail.date_shipped) > =-4 and shipper_detail.qty_packed>= shipper_detail.qty_original 
				THEN 'OnTime' 
			WHEN datediff(dd,shipper_detail.release_date, shipper_detail.date_shipped) > 4   or shipper_detail.qty_packed < shipper_detail.qty_original 
				THEN	 'Late'
			WHEN datediff(dd,shipper_detail.release_date, shipper_detail.date_shipped) < -4   
				THEN 'Early'
			ELSE 'Other' END) OnTime,
		shipper_detail.qty_required, 
		shipper_detail.qty_packed,
		shipper_detail.qty_original,
		destination.scheduler
FROM	part_eecustom part_eecustom, 
		shipper shipper, 
		shipper_detail shipper_detail,
		destination
WHERE	shipper.id = shipper_detail.shipper AND 
		shipper_detail.part = part_eecustom.part AND 
		shipper.destination = destination.destination AND
		shipper_detail.date_shipped>=@FromDate And shipper_detail.date_shipped< dateadd(dd,1,@ThroughDate) AND 
		shipper.customer<>'EEH' And shipper.customer Is Not Null AND 
		shipper_detail.qty_packed>0 and
		part_original not like '%-PT%' and
		isNULL(shipper.type, 'X')  not in ('R', 'V')

End


GO

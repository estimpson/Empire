SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create	procedure	[dbo].[eeisp_rpt_highFAB_Compare_Current_withReceipts]

as
Begin

--Created	2008-12-03	Andre S. Boulanger

--Delare Variables

Declare	@ReceiptPeriodID integer,
		@PeriodEndDT datetime


--Update POReceiptTotals

 exec EEH.FT.csp_RecordReceipts @ReceiptPeriodID output,@PeriodEndDT output, 0

--Getdata

Select	vendor_code,
		vw_eei_HighFABAuth.PONumber
		,vw_eei_HighFABAuth.Part
		,AccumReceived
		,AccumAdjust
		,AdjustedAccum
		,LastReceivedDT
		,HighFAB
		,HighFABWeek
		,ReleasePlanGenHighFAB
		,CurrentLeadTime
		,HighFABGeneratedWeek
		,POPrice
		,LastFABAuthReleasePlanID,
		AuthorizedAccum,
		ft.fn_TruncDate('wk',GeneratedDT) as LastFABAuthGenWeek,
		(HighFAB-AuthorizedAccum) as DiffHighFABCurrentFAB,
		(AuthorizedAccum-AdjustedAccum) as CurrentBalance,
		(HighFAB-AuthorizedAccum)*POPrice as DiffHighFABCurrentFABCost,
		(AuthorizedAccum-AdjustedAccum)*POPrice as CurrentBalanceCost,
		(Select	sum(quantity)
			from	audit_trail
			where	type = 'R' and
					dbDate >= ft.fn_TruncDate('wk',dateadd(dd,-7,getdate())) and
					part = vw_eei_HighFABAuth.Part and
					po_number = vw_eei_HighFABAuth.PONumber) as ReceiptsPriorWeekCurrent
		
from		vw_eei_HighFABAuth
join		ft.Fabauthorizations on vw_eei_HighFABAuth.PONUmber = ft.Fabauthorizations.PONumber and vw_eei_HighFABAuth.Part = ft.Fabauthorizations.Part and ReleasePlanID = LastFABAuthReleasePlanID
join		ft.ReleasePlans on ft.Fabauthorizations.ReleasePlanID = ft.ReleasePlans.ID
join		part_online on vw_eei_HighFABAuth.Part = part_online.part and  vw_eei_HighFABAuth.PONumber = part_online.default_po_number
where	
		exists	(
					Select	1
					from		ft.POreceiptTotals
					where	POnumber = vw_eei_HighFABAuth.PONumber and
							part = vw_eei_HighFABAuth.Part and
							LastReceivedDT >= ft.fn_TruncDate('wk',dateadd(dd,-7,getdate()))) and
		 vw_eei_HighFABAuth.PONumber not in  (
					select	distinct PONumber 
					from		ft.ReleasePlans
					join		ft.ReleasePlanRaw on ft.ReleasePlans.id = ft.ReleasePlanRaw.releasePlanID
					where	ft.fn_TruncDate('wk',GeneratedDT) >= dateadd(wk,-2, ft.fn_TruncDate('wk',getdate())) ) 
							

End
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	procedure	[dbo].[eeisp_rpt_highFAB_Compare_Current]

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
		(FourWeekPOReleases*POPrice) FourWeekPOCost
		
from		vw_eei_HighFABAuth
join		ft.Fabauthorizations on vw_eei_HighFABAuth.PONUmber = ft.Fabauthorizations.PONumber and vw_eei_HighFABAuth.Part = ft.Fabauthorizations.Part and ReleasePlanID = LastFABAuthReleasePlanID
join		ft.ReleasePlans on ft.Fabauthorizations.ReleasePlanID = ft.ReleasePlans.ID
join		part_online on vw_eei_HighFABAuth.Part = part_online.part and  vw_eei_HighFABAuth.PONumber = part_online.default_po_number
where	HighFABGeneratedWeek>= dateadd(m,-3,getdate())

End
GO

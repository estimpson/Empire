SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeisp_rpt_VendorOntimePerformanceperVendor] (@Vendor varchar(15))
as
begin
 
 
  
 SELECT			FT.vwVendorPerformance.PONumber, 
 				dbo.vendor.code, 
 				FT.vwVendorPerformance.Part, 
 				FT.vwVendorPerformance.WeekNo, 
 				dbo.vendor.name, 
 				FT.vwVendorPerformance.AccumOrdered, 
 				FT.vwVendorPerformance.OrderedReleasePlanID, 
 				FT.vwVendorPerformance.AuthorizedAccum, 
 				FT.vwVendorPerformance.AuthorizedReleasePlanID, 
 				FT.vwVendorPerformance.ReceivedAccum, 
 				FT.vwVendorPerformance.LastReceivedDT, 
 				FT.vwVendorPerformance.OnTime,
				(	Select max(postAccum)
					from	FT.ReleasePlanRaw RPR1
					where	RPR1.Part = FT.vwVendorPerformance.Part and
							RPR1.POnumber = FT.vwVendorPerformance.PONumber and
							RPR1.WeekNo <= FT.vwVendorPerformance.WeekNo and
							RPR1.ReleasePlanID = (	Select max(RPR2.ReleasePlanID)
													from	FT.ReleasePlanRaw RPR2,
															FT.ReleasePlans RP
													where	RP.ID = RPR2.ReleasePlanID and
															RP.GeneratedWeekNo < FT.vwVendorPerformance.WeekNo and
															RPR2.ReleasePlanID >= FT.vwVendorPerformance.AuthorizedReleasePlanID and
															RPR2.Part = FT.vwVendorPerformance.Part and
															RPR2.POnumber = FT.vwVendorPerformance.PONumber and
															RPR2.WeekNo <= FT.vwVendorPerformance.WeekNo)) as LastAccumOrdered


																	
 FROM			Monitor.FT.vwVendorPerformance,
 				Monitor.dbo.po_header  ,
 				Monitor.dbo.vendor 
 	WHERE		Ft.vwVendorPerformance.PONumber=dbo.po_header.po_number and
 				dbo.po_header.vendor_code=dbo.vendor.code and
				dbo.po_header.type = 'B'  and
				dbo.vendor.code = @vendor
 ORDER BY		dbo.vendor.code, FT.vwVendorPerformance.PONumber, FT.vwVendorPerformance.WeekNo

End
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeisp_ReleaseHistorybyVendor](@vendorcode varchar(15),@GeneratedDate datetime)
as
begin
  declare @ReleasePlanID integer
  begin transaction
  execute FT.csp_RecordVendorReleasePlan @ReleasePlanID=
  @ReleasePlanID
  commit transaction
  select ReleasePlanRaw.PONumber,
    ReleasePlanRaw.WeekNo,
    ReleasePlanRaw.DueDT,
    ReleasePlanRaw.ReleasePlanID,
    ReleasePlanRaw.StdQty,
    ReleasePlanRaw.PostAccum,
    ReleasePlanRaw.AccumReceived,
    ReleasePlanRaw.LastReceivedDT,
    ReleasePlanRaw.LastReceivedAmount,
    ReleasePlanRaw.FabWeekNo,
    ReleasePlans.GeneratedDT,
    POReceiptTotals.StdQty,
    POReceiptTotals.LastReceivedDT,
    po_header.blanket_part,
    po_header.vendor_code
    from FT.ReleasePlanRaw ReleasePlanRaw join
    FT.ReleasePlans ReleasePlans on ReleasePlanRaw.ReleasePlanID=ReleasePlans.ID join
    po_header on ReleasePlanRaw.poNumber=po_header.po_number left outer join
    FT.POReceiptTotals POReceiptTotals on ReleasePlanRaw.PONumber=POReceiptTotals.PONumber and ReleasePlanRaw.Part=POReceiptTotals.Part
    where po_header.type='B'
    and po_header.vendor_code=@vendorcode
    and ReleasePlans.GeneratedDT>=@GeneratedDate order by
    po_header.vendor_code asc,ReleasePlanRaw.PONumber asc
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[eeisp_report_LastReceivedperPartVendor]
as
begin
  select vendor,
    part_vendor.part,
    lead_time,
    lastReceiptDate=(select max(LastReceivedDT)
      from FT.POReceiptPeriods POReceiptPeriods join
      po_header on POReceiptPeriods.POnumber=po_number
      where po_header.vendor_code=part_vendor.vendor
      and POReceiptPeriods.Part=Part_vendor.part),
    current_vendor=part_online.default_vendor
    from part_vendor
	left outer join part_online on part_vendor.part=part_online.part and
	part_vendor.vendor=part_online.default_vendor
end
GO

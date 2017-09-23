SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[EEIsp_rpt_blanketPONewCrystal]
as
begin
  select distinct(case when part.cross_ref is null or part.cross_ref='' then part_vendor.vendor_part else part.cross_ref end),
    po_header.po_number,
    po_header.vendor_code,
    po_header.blanket_part,
    po_detail.unit_of_measure,
    po_detail.date_due,
    po_detail.quantity,
    po_detail.received,
    po_detail.balance,
    po_header.terms,
    po_header.fob,
    po_header.ship_via,
    po_header.plant,
    destination.name,
    destination.address_1,
    destination.address_2,
    destination.address_3,
    po_header.type,
    received_qty=isNULL((select(stdqty+accumadjust)
      from ft.poreceipttotals poreceipttotals
      where poreceipttotals.poNumber=po_header.po_number
      and poreceipttotals.part=po_header.blanket_part),0),
    part_vendor.lead_time,
    po_detail.alternate_price,
    vendor.contact,
    vendor.address_6,
    vendor.fax,
    vendor.phone,
    last_rec_date=(select LastReceivedDT
      from ft.poreceipttotals poreceipttotals
      where poreceipttotals.PONumber=po_header.po_number
      and poreceipttotals.Part=po_header.blanket_part),
    last_rec_id=(select isnull(max(audit_trail.shipper),'')
      from audit_trail
      where audit_trail.part=po_header.blanket_part
      and audit_trail.date_stamp=(select LastReceivedDT
      from ft.poreceipttotals poreceipttotals
      where poreceipttotals.PONumber=po_header.po_number
      and poreceipttotals.Part=po_header.blanket_part)
      and audit_trail.po_number=convert(varchar(30),po_header.po_number)
      and audit_trail.type='R')
    from po_header left outer join
    po_detail on po_header.po_number=po_detail.po_number join
    vendor on po_header.vendor_code=vendor.code join
    part on po_header.blanket_part=part.part join
    part_online on po_header.po_number=part_online.default_po_number left outer join
    destination on po_header.ship_to_destination=destination.destination left outer join
    part_vendor on po_header.blanket_part=part_vendor.part and po_header.vendor_code=part_vendor.vendor
    where po_header.type='B'
    and po_header.status<>'C' order by
    po_header.po_number asc,po_detail.date_due asc
end
GO

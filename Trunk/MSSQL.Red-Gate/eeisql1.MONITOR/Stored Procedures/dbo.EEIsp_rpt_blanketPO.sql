SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[EEIsp_rpt_blanketPO](@vendor varchar(15))
as
begin
  select part.cross_ref,
    po_detail.po_number,
    po_detail.vendor_code,
    po_detail.part_number,
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
    received_qty=isNULL((select sum(quantity)
      from audit_trail
      where audit_trail.date_stamp>=dateadd(yy,-1,getdate())
      and audit_trail.type='R'
      and audit_trail.po_number=convert(varchar(25),po_header.po_number)
      and year(date_stamp)=year(getdate())),0),
    cum_adjust_qty=isNULL((select sum(cum_adjust)
      from edi_po_year
      where edi_po_year.po_number=po_header.po_number
      and edi_po_year.year=year(getdate())),0),
    part_vendor.lead_time,
    po_detail.alternate_price,
    vendor.contact,
    vendor.address_6,
    vendor.fax,
    vendor.phone,
    last_rec_date=(select max(date_stamp)
      from audit_trail
      where audit_trail.date_stamp>=dateadd(yy,-1,getdate())
      and audit_trail.type='R'
      and audit_trail.po_number=convert(varchar(25),po_header.po_number)
      and year(date_stamp)=year(getdate()))
    from po_detail join
    po_header on po_detail.po_number=po_header.po_number join
    vendor on po_header.vendor_code=vendor.code join
    part on po_detail.part_number=part.part join
    part_online on po_header.po_number=part_online.default_po_number left outer join
    destination on po_header.ship_to_destination=destination.destination left outer join
    part_vendor on po_header.blanket_part=part_vendor.part and po_header.vendor_code=part_vendor.vendor
    where po_header.type='B'
    and vendor.code=@vendor
    and po_header.vendor_code=@vendor order by
    po_header.po_number asc,po_detail.date_due asc
end
GO

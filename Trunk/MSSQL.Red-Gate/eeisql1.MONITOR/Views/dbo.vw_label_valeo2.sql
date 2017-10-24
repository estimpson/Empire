SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_label_valeo2](part,
  lot,
  last_date,
  qty,
  customerpo,
  destinationname,
  ecl,
  supplier,
  custpart,
  serialno,
  partname,
  PQA)
  as select UPPER(audit_trail.part),
    UPPER(audit_trail.lot),
    audit_trail.date_stamp,
    convert(integer,audit_trail.quantity),
    UPPER(isNULL(shipper_detail.customer_po,order_header.customer_po)),
    UPPER(destination."name"),
    UPPER(order_header.engineering_level),
    UPPER(edi_setups.supplier_code),
    UPPER(isNULL(shipper_detail.customer_part,order_header.customer_part)),
    audit_trail.serial,
    UPPER(part."name"),
    (case when UPPER(isNULL(order_header.notes,'X')) like '%NO PQA%' then 1 else 0 end)
    from dbo.audit_trail
    ,dbo.shipper
    ,dbo.shipper_detail
    ,dbo.order_header
    ,dbo.destination
    ,dbo.edi_Setups
    ,dbo.part
    ,dbo.customer
    where audit_trail.shipper='21002'
    and audit_trail.part=order_header.blanket_part
    and shipper.destination=edi_setups.destination
    and order_header.destination=edi_setups.destination
    and edi_setups.destination=destination.destination
    and order_header.customer=customer.customer
    and audit_trail.part=part.part
    and audit_trail.shipper=Shipper.id
    and audit_trail.shipper=shipper_detail.shipper
    and audit_trail.part=shipper_detail.part_original
    and audit_trail."type"='S'
GO

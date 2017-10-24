SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view
  [dbo].[vwInalfaReLabel](shipper,
  part,
  cust_part,
  ecl,
  po_number,
  supplier,
  serial,
  lot,
  destination,
  address_1,
  address_2,
  address_3,
  parms_co,
  parms_add1,
  parms_add2,
  dock_code,
  pname,
  pcross,
  mfg_date,
  quantity,
  mhandle,
  ptype)
  as select shipper=shipper.id,
    part=shipper_detail.part_original,
    cust_part=shipper_detail.customer_part,
    ecl=order_header.engineering_level,
    po_number=shipper_detail.customer_po,
    supplier=edi_setups.supplier_code,
    serial=object.serial,
    lot=(select substring(convert(varchar(20),datepart(year,getdate())),3,2)+ substring(convert(varchar(20),datepart(dy,getdate())),1,20)),
    destination=destination."name",
    address_1=destination.address_1,
    address_2=destination.address_2,
    address_3=destination.address_3,
    parms_co=parameters.company_name,
    parms_add1=parameters.address_1,
    parms_add2=parameters.address_2,
    dock_code=order_header.dock_code,
    pname=part."name",
    pcross=part.cross_ref,
    mfg_date=convert(varchar(20),getdate(),1),
    quantity=convert(integer,object.quantity),
    mhandle=order_header.line_feed_code,
    ptype=(case when part.part like '%PT' then 'ENG SAMPLE' when isNULL(ServicePart,'N')='Y' then 'SERVICE' else 'PRODUCTION'
    end)
    from dbo.shipper
    ,dbo.shipper_detail
    ,dbo.order_header
    ,dbo.edi_setups
    ,dbo.destination
    ,dbo.parameters
    ,dbo.object
    ,dbo.part
    ,dbo.part_eecustom
    where shipper.id=shipper_detail.shipper
    and object.shipper=shipper.id
    and object.part=shipper_detail.part_original
    and shipper.destination=destination.destination
    and destination.destination=edi_setups.destination
    and order_header.order_no=shipper_detail.order_no
    and shipper_detail.part_original like 'INA%'
    and shipper.status='S'
    and part.part=shipper_detail.part_original
    and part_eecustom.part=part.part
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view
  [dbo].[vw_eei_label_MitsuMasterLabel](shipper,
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
  partname)
  /*	Description:*/
  /*	Select shipper data to be used with Mitsubishi Master Label Matrix Label*/
  as
select shipper=shipper.id,
    part=shipper_detail.part_original,
    cust_part=shipper_detail.customer_part,
    ecl=order_header.engineering_level,
    po_number=shipper_detail.customer_po,
    supplier=edi_setups.supplier_code,
    serial=(select max(object.serial) from dbo.object where object.shipper=shipper.id and object.part=shipper_detail.part_original),
    lot=(select substring(convert(varchar(4),datepart(yy,getdate())),3,2)+convert(varchar(10),datepart(dy,getdate()))),
    destination=destination."name",
    address_1=destination.address_1,
    address_2=destination.address_2,
    address_3=destination.address_3,
    parms_co=parameters.company_name,
    parms_add1=parameters.address_1,
    parms_add2=parameters.address_2,
    part.name
    from dbo.shipper
    ,dbo.shipper_detail
    ,dbo.order_header
    ,dbo.edi_setups
    ,dbo.destination
    ,dbo.parameters,
	dbo.part
    where shipper.id=shipper_detail.shipper
    and shipper.destination=destination.destination
    and destination.destination=edi_setups.destination
    and order_header.order_no=shipper_detail.order_no
    and shipper_detail.part_original = part.part
    and shipper_detail.part_original like '%MIT%'
    and shipper.status='S'
    group by shipper.id,
    shipper_detail.customer_part,
    shipper_detail.part_original,
    order_header.engineering_level,
    shipper_detail.customer_po,
    edi_setups.supplier_code,
    
    destination.name,
    destination.address_1,
    destination.address_2,
    destination.address_3,
    parameters.company_name,
    parameters.address_1,
    parameters.address_2,
    part.name
GO

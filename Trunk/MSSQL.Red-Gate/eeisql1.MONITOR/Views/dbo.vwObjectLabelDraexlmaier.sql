SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [dbo].[vwObjectLabelDraexlmaier]
as 

Select	sd.customer_part as CustomerPart,
		ob.Quantity as SerialQty,
		coalesce(es.supplier_code,'047380894') as SupplierCode,
		coalesce(ob.Lot,ob.serial) as LotNumber,
		sd.customer_po as CustomerPO,
		oh.Line12 as LineFeedCode,
		oh.line11 as SPIPartDescription,
		d.address_1 as Address1,
		d.address_2 as Address2,
		d.address_3 as Address3,
		coalesce(s.bill_of_lading_number, s.id) as BOL_SID,
		p.address_1 as CompanyAdd1,
		p.address_2 as CompanyAdd2,
		p.company_name as Companyname,
		ob.serial as Serial
From
	shipper_detail sd
join
	shipper s on s.id = sd.shipper
join
	destination d on s.destination = d.destination
join
	order_header oh on sd.order_no = oh.order_no
join
	edi_setups es on es.destination = s.destination
join
	object ob on ob.shipper =  sd.shipper
cross join
	parameters p
where
	parent_serial is Not Null and
	ob.part != 'PALLET' and
	ob.part like 'DRA%'

union
Select	sd.customer_part as CustomerPart,
		ob.Quantity as SerialQty,
		coalesce(es.supplier_code,'047380894') as SupplierCode,
		coalesce(ob.Lot,ob.serial) as LotNumber,
		sd.customer_po as CustomerPO,
		oh.Line12 as LineFeedCode,
		oh.line11 as SPIPartDescription,
		d.address_1 as Address1,
		d.address_2 as Address2,
		d.address_3 as Address3,
		coalesce(s.bill_of_lading_number, s.id) as BOL_SID,
		p.address_1 as CompanyAdd1,
		p.address_2 as CompanyAdd2,
		p.company_name as Companyname,
		ob.serial as Serial
From
	shipper_detail sd
join
	shipper s on s.id = sd.shipper
join
	destination d on s.destination = d.destination
join
	order_header oh on sd.order_no = oh.order_no
join
	edi_setups es on es.destination = s.destination
join
	audit_trail ob on ob.shipper =  sd.shipper
cross join
	parameters p
where
	parent_serial is Not Null and
	ob.part != 'PALLET' and
	ob.type = 'S' and
	ob.part like 'DRA%'





GO

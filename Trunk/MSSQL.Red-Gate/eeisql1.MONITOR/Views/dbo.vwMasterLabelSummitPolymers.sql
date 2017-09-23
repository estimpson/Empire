SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[vwMasterLabelSummitPolymers]
as 

Select	max(sd.customer_part) as CustomerPart,
		sum(ob.Quantity) as PalletSerialQty,
		max(coalesce(es.supplier_code,'047380894')) as SupplierCode,
		max(coalesce(ob.Lot,ob.serial)) as LotNumber,
		max(sd.customer_po) as CustomerPO,
		max(oh.Line12) as LineFeedCode,
		max(oh.line11) as SPIPartDescription,
		max(d.address_1) as Address1,
		max(d.address_2) as Address2,
		max(d.address_3) as Address3,
		max(coalesce(s.bill_of_lading_number, s.id)) as BOL_SID,
		max(p.address_1) as CompanyAdd1,
		max(p.address_2) as CompanyAdd2,
		max(p.company_name) as Companyname,
		ob.parent_serial as PalletSerial
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
	ob.part like 'SUM%'
group by
	ob.parent_serial
/*union
Select	max(sd.customer_part) as CustomerPart,
		sum(ob.Quantity) as PalletSerialQty,
		max(coalesce(es.supplier_code,'047380894')) as SupplierCode,
		max(coalesce(ob.Lot,ob.serial)) as LotNumber,
		max(sd.customer_po) as CustomerPO,
		max(oh.Line12) as LineFeedCode,
		max(oh.line11) as SPIPartDescription,
		max(d.address_1) as Address1,
		max(d.address_2) as Address2,
		max(d.address_3) as Address3,
		max(coalesce(s.bill_of_lading_number, s.id)) as BOL_SID,
		max(p.address_1) as CompanyAdd1,
		max(p.address_2) as CompanyAdd2,
		max(p.company_name) as Companyname,
		ob.parent_serial as PalletSerial
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
	ob.part like 'SUM%'
group by
	ob.parent_serial
*/


GO

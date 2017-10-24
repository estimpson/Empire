SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_LabelMasterMitsubishi]
as
select		isNULL(object.parent_serial, 0) as ParentSerial,
			COALESCE(ShipCustomerPart,Part.cross_ref) as CustomerPart,
			COALESCE(ShipCustomerPO,'RELABEL') as CustomerPO,
			Sum(Object.Quantity) as Quantity,
			COALESCE(ShipSupplierCode, 'Add Supplier Code') as SupplierCode,
			isNULL((select max(date_stamp) from audit_trail where type in ('J', 'A','R') and audit_trail.parent_serial = object.parent_serial), getdate()) as MfgDate,
			Parameters.company_name as CompanyName,
			Parameters.address_1 as CompanyAdd1,
			Parameters.address_2 as CompanyAdd2,
			Parameters.address_3 as CompanyAdd3
From		object
Join			part on object.part = part.part
cross Join	parameters
left join	(Select		isNULL(order_header.blanket_part, ' ') as ShipBlanketPart,
					isNULL(order_header.customer_part, ' ') as ShipCustomerPart,
					isNULL(order_header.customer_po, ' ') as ShipCustomerPO,
					isNULL(order_header.engineering_level, ' ') as ShipCustomerRevLevel,
					isNULL(order_header.destination, ' ') as ShipDestination,
					isNULL(order_header.line_feed_code, ' ') as ShipLineFeedCode,
					isNULL(Order_Header.Line11,' ') as ShipLine11,
					isNULL(Order_Header.Line12,' ') as ShipLine12,
					isNULL(Order_Header.Line13,' ') as ShipLine13,
					isNULL(Order_Header.Line14,' ') as ShipLine14,
					isNULL(Order_Header.Line15,' ') as ShipLine15,
					isNULL(Order_Header.Line16,' ') as ShipLine16,
					isNULL(Order_Header.Line17,' ') as ShipLine17,
					isNULL(Order_Header.Zone_Code,' ') as ShipZoneCode,
					isNULL(order_header.dock_code,' ') as ShipDockCode,
					isNULL(order_Header.notes, ' ') as ShipNotes,
					isNULL(edi_setups.supplier_code, ' ') as ShipSupplierCode,
					isNULL(edi_setups.parent_destination, ' ') as ShipPlant,
					isNULL(Destination.Name,  ' ') as Shipdestinationname,
					isNULL(Destination.Address_1, ' ') as ShipDestinationAdd1,
					isNULL(Destination.Address_2, ' ') as ShipDestinationAdd2,
					isNULL(Destination.Address_3, ' ') as ShipDestinationAdd3,
					isNULL(Customer.customer, ' ') as Shipcustomer,
					isNULL(Customer.name, ' ') as Shipcustomername,
					isNULL(Customer.address_1, ' ') as ShipCustomerAdd1,
					isNULL(Customer.address_2, ' ') as ShipCustomerAdd2,
					isNULL(Customer.address_3, ' ') as ShipCustomerAdd3,
					OHObject.serial as ShipSerial
			from		object OHObject
			join		order_header as order_header on OHObject.part = order_header.blanket_part
			join		edi_setups as edi_setups on order_header.destination = edi_setups.destination
			join		destination as destination on order_header.destination = destination.destination
			join		customer as customer on order_header.customer = customer.customer
			join		shipper on OHObject.shipper = shipper.id
			join		shipper_detail on shipper.id = shipper_detail.shipper and shipper_detail.part_original = OHObject.part and shipper_detail.order_no = order_header.order_no
			 ) Shipper on object.serial = ShipSerial

Group by 	object.parent_serial,
			COALESCE(ShipCustomerPart,Part.cross_ref) ,
			COALESCE(ShipCustomerPO,'RELABEL') ,
			COALESCE(ShipSupplierCode, 'Add Supplier Code'),
			Parameters.company_name ,
			Parameters.address_1 ,
			Parameters.address_2 ,
			Parameters.address_3 
GO

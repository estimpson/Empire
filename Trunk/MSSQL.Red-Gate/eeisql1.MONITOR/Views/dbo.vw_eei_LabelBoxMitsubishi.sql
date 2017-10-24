SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_LabelBoxMitsubishi]
as
select		object.serial as objectserial,
			COALESCE(ShipCustomerPart,OHCustomerPart,Part.cross_ref) as CustomerPart,
			COALESCE(ShipCustomerPO,OHCustomerPO,'RELABEL') as CustomerPO,
			Object.Quantity as Quantity,
			isNULL(Object.Lot,'') as Lot,
			COALESCE(ShipSupplierCode,OHSupplierCode, 'Add Supplier Code') as SupplierCode,
			Part.Name as PartName,
			Part.Cross_Ref,
			COALESCE(ShipCustomerRevLevel, OHCustomerRevLevel, ' ') as EngineeringLevel,
			isNULL((select max(date_stamp) from audit_trail where type in ('J', 'A','R') and serial = object.serial), getdate()) as MfgDate,
			getdate() as ShipDate,
			Parameters.company_name as CompanyName,
			Parameters.address_1 as CompanyAdd1,
			Parameters.address_2 as CompanyAdd2,
			Parameters.address_3 as CompanyAdd3,
			COALESCE(ShipDestination,OHdestination, ' ') as Destination,
			OHdestinationname as destinationname,
			OHDestinationAdd1 as DestinationAdd1,
			OHDestinationAdd2 as DestinationAdd2,
			OHDestinationAdd3 as DestinationAdd3,
			COALESCE(ShipLineFeedCode, OHLineFeedCode,' ') as LineFeed,
			COALESCE(ShipLine11,OHLine11,' ') as Line11,
			COALESCE(ShipLine12,OHLine12,'') as Line12,
			COALESCE(ShipLine13,OHLine13,'') as Line13,
			COALESCE(ShipLine14,OHLine14,'') as Line14,
			COALESCE(ShipLine15,OHLine15,'') as Line15,
			COALESCE(ShipLine16,OHLine16,'') as Line16,
			COALESCE(ShipLine17,OHLine17,'') as Line17,
			COALESCE(ShipZoneCode,OHZoneCode,'') as ZoneCode,
			object.weight  as Objectweight,
			object.tare_weight as Objecttareweight,
			object.shipper as objectshipper,
			isNULL(object.parent_serial, 0) as ParentSerial,
			isnull(object.kanban_number,'') as KanBanNo,
			COALESCE(ShipDockCode, OHDockCode, ' ') as DockCode,
			COALESCE(ShipCustomer,OHCustomer, ' ') as customer,
			COALESCE(ShipCustomerName, OHCustomername, ' ' ) as customername,
			COALESCE(ShipCustomerAdd1, OHCustomerAdd1,' ') as CustomerAdd1,
			COALESCE(ShipCustomerAdd2, OHCustomerAdd2, ' ') as CustomerAdd2,
			COALESCE(ShipCustomerAdd3, OHCustomerAdd3, ' ') as CustomerAdd3,
			object.part as ObjectPart,
			part.drawing_number as FedMogulCrossRef,
			OHNotes as ordernotes,
			COALESCE(OHPlant, 'PLANT') as PlantCode
From		object
Join			part on object.part = part.part
cross Join	parameters
Left Join		(Select	isNULL(order_header.blanket_part, ' ') as OHBlanketPart,
					isNULL(order_header.customer_part, ' ') as OHCustomerPart,
					isNULL(order_header.customer_po, ' ') as OHCustomerPO,
					isNULL(order_header.engineering_level, ' ') as OHCustomerRevLevel,
					isNULL(order_header.destination, ' ') as OHDestination,
					isNULL(order_header.line_feed_code, ' ') as OHLineFeedCode,
					isNULL(Order_Header.Line11,' ') as OHLine11,
					isNULL(Order_Header.Line12,' ') as OHLine12,
					isNULL(Order_Header.Line13,' ') as OHLine13,
					isNULL(Order_Header.Line14,' ') as OHLine14,
					isNULL(Order_Header.Line15,' ') as OHLine15,
					isNULL(Order_Header.Line16,' ') as OHLine16,
					isNULL(Order_Header.Line17,' ') as OHLine17,
					isNULL(Order_Header.Zone_Code,' ') as OHZoneCode,
					isNULL(order_header.dock_code,' ') as OHDockCode,
					isNULL(order_Header.notes, ' ') as OHNotes,
					isNULL(edi_setups.supplier_code, ' ') as OHSupplierCode,
					isNULL(edi_setups.parent_destination, ' ') as OHPlant,
					isNULL(Destination.Name,  ' ') as OHdestinationname,
					isNULL(Destination.Address_1, ' ') as OHDestinationAdd1,
					isNULL(Destination.Address_2, ' ') as OHDestinationAdd2,
					isNULL(Destination.Address_3, ' ') as OHDestinationAdd3,
					isNULL(Customer.customer, ' ') as OHcustomer,
					isNULL(Customer.name, ' ') as OHcustomername,
					isNULL(Customer.address_1, ' ') as OHCustomerAdd1,
					isNULL(Customer.address_2, ' ') as OHCustomerAdd2,
					isNULL(Customer.address_3, ' ') as OHCustomerAdd3,
					OHObject.serial as OHSerial
			from		object OHObject
			join		order_header as order_header on OHObject.part = order_header.blanket_part
			join		edi_setups as edi_setups on order_header.destination = edi_setups.destination
			join		destination as destination on order_header.destination = destination.destination
			join		customer as customer on order_header.customer = customer.customer
			where	order_header.order_no = (Select		min(order_header2.order_no)
																			from		order_header as order_header2
																			left join	vw_eei_mitsubishi_inventory on order_header2.blanket_part = vw_eei_mitsubishi_inventory.part and order_header2.customer_po = vw_eei_mitsubishi_inventory.PONumber
																			where	OHObject.part= order_header2.blanket_part and
																					(isNULL(qty,0)+isNULL(our_cum,0))<isNULL(raw_cum,0)	 and
																					order_header2.blanket_part = order_header.Blanket_Part)
																					
					) OrderHeader 
			
on			object.serial = OHSerial
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
GO

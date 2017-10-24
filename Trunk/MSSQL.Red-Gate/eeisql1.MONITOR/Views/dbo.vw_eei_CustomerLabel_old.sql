SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[vw_eei_CustomerLabel_old]
as
select		object.serial as objectserial,
			isNULL(shipper_detail.customer_part,order_header.customer_part) as CustomerPart,
			isNULL(shipper_detail.customer_po,order_header.customer_po) as CustomerPO,
			Object.Quantity as Quantity,
			isNULL(Object.Lot,'') as Lot,
			isNULL(EDI_Setups.Supplier_Code,'') as SupplierCode,
			Part.Name as PartName,
			Part.Cross_Ref,
			Order_header.Engineering_level as EngineeringLevel,
			isNULL((select max(date_stamp) from audit_trail where type in ('J', 'A','R') and serial = object.serial), getdate()) as MfgDate,
			getdate() as ShipDate,
			Parameters.company_name as CompanyName,
			Parameters.address_1 as CompanyAdd1,
			Parameters.address_2 as CompanyAdd2,
			Parameters.address_3 as CompanyAdd3,
			Order_Header.destination as Destination,
			Destination.Name as destinationname,
			Destination.Address_1 as DestinationAdd1,
			Destination.Address_2 as DestinationAdd2,
			Destination.Address_3 as DestinationAdd3,
			isNULL(Order_Header. Line_Feed_code,'') as LineFeed,
			isNULL(Order_Header.Line11,'') as Line11,
			isNULL(Order_Header.Line12,'') as Line12,
			isNULL(Order_Header.Line13,'') as Line13,
			isNULL(Order_Header.Line14,'') as Line14,
			isNULL(Order_Header.Line15,'') as Line15,
			isNULL(Order_Header.Line16,'') as Line16,
			isNULL(Order_Header.Line17,'') as Line17,
			isNULL(Order_Header.Zone_Code,'') as ZoneCode,
			object.weight  as Objectweight,
			object.tare_weight as Objecttareweight,
			object.shipper as objectshipper,
			isNULL(object.parent_serial, 0) as ParentSerial,
			isnull(object.kanban_number,'') as KanBanNo,
			isNULL(shipper.shipping_dock, order_header.dock_code) as DockCode,
			Customer.customer as customer,
			Customer.name as customername,
			Customer.address_1 as CustomerAdd1,
			Customer.address_2 as CustomerAdd2,
			Customer.address_3 as CustomerAdd3,
			object.part as ObjectPart,
			part.drawing_number as FedMogulCrossRef,
			order_header.notes as ordernotes,
			isNULL(edi_setups.parent_destination, 'PLANT') as PlantCode
From	object,
			part as part,
			order_header as order_header,
			Customer as customer,
			Destination as destination,
			edi_setups as edi_setups,
			shipper_detail as shipper_detail,
			shipper as shipper,
			parameters as parameters
where		object.part = order_header.blanket_part and
			object.part = part.part and
			order_header.customer = customer.customer and
			order_header.destination = destination.destination and
			edi_setups.destination = destination.destination and
			object.shipper=shipper.id and
			object.shipper =shipper_detail.shipper and
			object.part =shipper_detail.part_original and
			order_header.order_no = shipper_detail.order_no and
			ORDER_HEADER.CUSTOMER_PART = SHIPPER_DETAIL.CUSTOMER_PART AND
			isNULL(object.shipper, order_header.order_no) = (Select	max(isNULL(o2.shipper, order_header.order_no)) 
															from		order_header as order_header,
																		shipper_detail,
																		object o2
															where		order_header.order_no = shipper_detail.order_no and
																		order_header.blanket_part = part.part and
																		o2.serial = object.serial AND
																		SHIPPER_DETAIL.SHIPPER = O2.SHIPPER)
GO

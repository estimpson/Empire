SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_CustomerLabel_master]
as
select  object.serial as objectserial,
			isNULL(shipper_detail.customer_part,order_header.customer_part) as CustomerPart,
			isNULL(shipper_detail.customer_po,order_header.customer_po) as CustomerPO,
			Object.Quantity as Quantity,
			Object.Lot as Lot,
			EDI_Setups.Supplier_Code as SupplierCode,
			Part.Name as PartName,
			Part.Cross_Ref,
			Order_header.Engineering_level as EngineeringLevel,
			isNULL((select max(date_stamp) from audit_trail where type in ('J', 'A') and serial = object.serial), getdate()) as MfgDate,
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
			Order_Header. Line_Feed_code as LineFeed,
			Order_Header.Line11 as Line11,
			Order_Header.Line12 as Line12,
			Order_Header.Line13 as Line13,
			Order_Header.Line14 as Line14,
			Order_Header.Line15 as Line15,
			Order_Header.Line16 as Line16,
			Order_Header.Line17 as Line17,
			Order_Header.Zone_Code as ZoneCode,
			object.weight  as Objectweight,
			object.tare_weight as Objecttareweight,
			object.shipper as objectshipper,
			isNULL(object.parent_serial, 0) as ParentSerial,
			object.kanban_number as KanBanNo,
			isNULL(shipper.shipping_dock, order_header.dock_code) as DockCode,
			Customer.customer as customer,
			Customer.name as customername,
			Customer.address_1 as CustomerAdd1,
			Customer.address_2 as CustomerAdd2,
			Customer.address_3 as CustomerAdd3,
			object.part as ObjectPart,
			part.drawing_number as FedMogulCrossRef,
			order_header.notes as ordernotes,
			isNULL(edi_setups.parent_destination, 'PLANT') as PlantCode,
			(select sum(quantity) from object o2 where o2.parent_serial =object.parent_serial and object.part = o2.part) as MasterPalletQty,
			object.parent_serial as MasterSerial
From	object
		join part as part
			on object.part = part.part
		join order_header as order_header
			on object.part = order_header.blanket_part
		join Customer as customer
			on order_header.customer = customer.customer
		join Destination as destination
			on order_header.destination = destination.destination
		join edi_setups as edi_setups
			on edi_setups.destination = destination.destination
		left join shipper_detail as shipper_detail
			on object.shipper = shipper_detail.shipper
			and object.part = shipper_detail.part_original
			and order_header.order_no = shipper_detail.order_no
		left join shipper as shipper
			on object.shipper = shipper.id
		cross join parameters as parameters
where	coalesce(order_header.shipper, order_header.order_no) =
			(	select		max(coalesce(order_header.shipper, order_header.order_no)) 
				from		order_header as order_header
							left join shipper_detail
								on order_header.order_no = shipper_detail.order_no
				where		order_header.blanket_part = part.part)
GO

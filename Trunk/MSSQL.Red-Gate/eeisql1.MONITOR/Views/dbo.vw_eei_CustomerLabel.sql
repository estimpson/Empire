SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE view [dbo].[vw_eei_CustomerLabel]
as
select		object.serial as objectserial,
			COALESCE( oh1CustomerPart, oh2CustomerPart, oh3CustomerPart, 'No Customer Part') as CustomerPart,
			COALESCE( oh1CustomerPO, oh2CustomerPO, oh3CustomerPO, 'No Customer PO') as CustomerPO,
			Object.Quantity as Quantity,
			isNULL(Object.Lot,'1') as Lot,
			COALESCE( es1SupplierCode, es2SupplierCode, es3SupplierCode, 'No Supplier') as SupplierCode,
			Part.Name as PartName,
			Part.Cross_Ref,
			COALESCE( oh1RevLevel, oh2RevLevel, oh3RevLevel, 'No Cust Rev') as EngineeringLevel,
			COALESCE( mfgDT, getdate(), ' ')  as MfgDate,
			getdate() as ShipDate,
			Parameters.company_name as CompanyName,
			Parameters.address_1 as CompanyAdd1,
			Parameters.address_2 as CompanyAdd2,
			Parameters.address_3 as CompanyAdd3,
			COALESCE( oh1Destination, oh2Destination, oh3Destination, 'No Destination') as Destination,
			COALESCE( d1name, d2name, d3name, 'No Dest Name') as destinationname,
			COALESCE( d1add1, d2add1, d3add1, ' ') as DestinationAdd1,
			COALESCE( d1add2, d2add2, d3add2, ' ') as DestinationAdd2,
			COALESCE( d1add3, d2add3, d3add3, ' ')as DestinationAdd3,
			COALESCE( oh1LineFeed, oh2LineFeed, oh3LineFeed, ' ') as LineFeed,
			COALESCE( oh1Line11, oh2Line11, oh3Line11, ' ') as Line11,
			COALESCE( oh1Line12, oh2Line12, oh3Line12, ' ') as Line12,
			COALESCE( oh1Line13, oh2Line13, oh3Line13, ' ') as Line13,
			COALESCE( oh1Line14, oh2Line14, oh3Line14, ' ') as Line14,
			COALESCE( oh1Line15, oh2Line15, oh3Line15, ' ') as Line15,
			COALESCE( oh1Line16, oh2Line16, oh3Line16, ' ') as Line16,
			COALESCE( oh1Line17, oh2Line17, oh3Line17, ' ') as Line17,
			COALESCE( oh1ZoneCode, oh2ZoneCode, oh3ZoneCode, ' ') as ZoneCode,
			ISNULL(object.weight, 0.01) as Objectweight,
			object.tare_weight as Objecttareweight,
			shipperid as objectshipper,
			isNULL(object.parent_serial, 0) as ParentSerial,
			isnull(object.kanban_number,'') as KanBanNo,
			COALESCE( oh1DockCode, oh2DockCode, oh3DockCode, ' ') as DockCode,
			COALESCE( c1customer, c2customer, c3customer, 'No Customer') as customer,
			COALESCE( c1name, c2name, c3name, 'No Customer Name') as customername,
			COALESCE( c1add1, c2add1, c3add1, ' ') as CustomerAdd1,
			COALESCE( c1add2, c2add2, c3add2, ' ') as CustomerAdd2,
			COALESCE( c1add3, c2add3, c3add3, ' ') as CustomerAdd3,
			object.part as ObjectPart,
			part.drawing_number as FedMogulCrossRef,
			COALESCE( oh1notes, oh2notes, oh3notes, ' ') as ordernotes,
			COALESCE( es1PlantCode, es2PlantCode, es3PlantCode, ' ') as PlantCode,
			COALESCE( mfgDT, getdate(), ' ') as MfgDateDT,
			isnull (part.InfoRecord,'0') as SLAInfoRecord,SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ12345', YEAR(GETDATE()) - 2004, 1) 
                      + SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ12345', MONTH(GETDATE()), 1) + SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ12345', DAY(GETDATE()), 1)  AS SLALotNo, Boxes = coalesce(dbo.object.field1,'RELABEL') ,
					  Indexno=(SELECT IndexNo  FROM part_characteristics  WHERE part=object.part)
From		object
join			part on object.part = part.part
cross join	parameters
left join			(	Select	oh3.order_no			oh3OrderderNo,
							oh3.blanket_part		oh3BlanketPart,
							oh3.customer_part	oh3CustomerPart,
							oh3.customer_po		oh3CustomerPO,
							es3.supplier_code		es3SupplierCode,
							oh3.engineering_level	oh3RevLevel,
							oh3.destination		oh3Destination,
							d3.Name as d3name,
							d3.Address_1 as d3Add1,
							d3.Address_2 as d3Add2,
							d3.Address_3 as d3Add3,
							isNULL(oh3. Line_Feed_code,'') as oh3LineFeed,
							isNULL(oh3.Line11,'') as oh3Line11,
							isNULL(oh3.Line12,'') as oh3Line12,
							isNULL(oh3.Line13,'') as oh3Line13,
							isNULL(oh3.Line14,'') as oh3Line14,
							isNULL(oh3.Line15,'') as oh3Line15,
							isNULL(oh3.Line16,'') as oh3Line16,
							isNULL(oh3.Line17,'') as oh3Line17,
							isNULL(oh3.Zone_Code,'') as oh3ZoneCode,
							isNULL(oh3.dock_code,'') as oh3DockCode,
							c3.customer as c3customer,
							c3.name as c3name,
							c3.address_1 as c3Add1,
							c3.address_2 as c3Add2,
							c3.address_3 as c3Add3,
							oh3.notes as oh3notes,
							isNULL(es3.parent_destination, 'PLANT') as es3PlantCode,
							o3.serial o3Serial							
					from		order_header oh3,
							edi_setups es3,
							destination d3,
							customer c3,
							object o3
					where	oh3.blanket_part = o3.part and
							es3.destination = oh3.destination and
							d3.destination = es3.destination and
							oh3.customer = c3.customer and oh3.order_no = (Select		max(order_no)
																		from		order_header oh4
																		where	oh4.blanket_part = o3.part	) ) lastorder on  object.serial = o3Serial

left join			(	Select	oh2.order_no			oh2OrderderNo,
							oh2.blanket_part		oh2BlanketPart,
							oh2.customer_part	oh2CustomerPart,
							oh2.customer_po		oh2CustomerPO,
							es2.supplier_code		es2SupplierCode,
							oh2.engineering_level	oh2RevLevel,
							oh2.destination		oh2Destination,
							d2.Name as d2name,
							d2.Address_1 as d2Add1,
							d2.Address_2 as d2Add2,
							d2.Address_3 as d2Add3,
							isNULL(oh2. Line_Feed_code,'') as oh2LineFeed,
							isNULL(oh2.Line11,'') as oh2Line11,
							isNULL(oh2.Line12,'') as oh2Line12,
							isNULL(oh2.Line13,'') as oh2Line13,
							isNULL(oh2.Line14,'') as oh2Line14,
							isNULL(oh2.Line15,'') as oh2Line15,
							isNULL(oh2.Line16,'') as oh2Line16,
							isNULL(oh2.Line17,'') as oh2Line17,
							isNULL(oh2.Zone_Code,'') as oh2ZoneCode,
							isNULL(oh2.dock_code,'') as oh2DockCode,
							c2.customer as c2customer,
							c2.name as c2name,
							c2.address_1 as c2Add1,
							c2.address_2 as c2Add2,
							c2.address_3 as c2Add3,
							oh2.notes as oh2notes,
							isNULL(es2.parent_destination, 'PLANT') as es2PlantCode	,
							o2.serial as o2Serial						
					from		order_header oh2,
							edi_setups es2,
							destination d2,
							customer c2,
							object o2
					where	oh2.blanket_part = o2.part and
							es2.destination = oh2.destination and
							d2.destination = es2.destination and
							oh2.customer = c2.customer and oh2.order_no =  (Select	min(order_no) 
																from		order_detail 
																where	due_date>= getdate() and 
																		order_detail.part_number = o2.part)) demandorder on  object.serial = o2serial

left join			(	Select	oh1.order_no	oh1OrderderNo,
							oh1.blanket_part		oh1BlanketPart,
							oh1.customer_part	oh1CustomerPart,
							oh1.customer_po		oh1CustomerPO,
							es1.supplier_code		es1SupplierCode,
							oh1.engineering_level	oh1RevLevel,
							oh1.destination		oh1Destination,
							d1.Name as d1name,
							d1.Address_1 as d1Add1,
							d1.Address_2 as d1Add2,
							d1.Address_3 as d1Add3,
							isNULL(oh1. Line_Feed_code,'') as oh1LineFeed,
							isNULL(oh1.Line11,'') as oh1Line11,
							isNULL(oh1.Line12,'') as oh1Line12,
							isNULL(oh1.Line13,'') as oh1Line13,
							isNULL(oh1.Line14,'') as oh1Line14,
							isNULL(oh1.Line15,'') as oh1Line15,
							isNULL(oh1.Line16,'') as oh1Line16,
							isNULL(oh1.Line17,'') as oh1Line17,
							isNULL(oh1.Zone_Code,'') as oh1ZoneCode,
							isNULL(oh1.dock_code,'') as oh1DockCode,
							c1.customer as c1customer,
							c1.name as c1name,
							c1.address_1 as c1Add1,
							c1.address_2 as c1Add2,
							c1.address_3 as c1Add3,
							oh1.notes as oh1notes,
							isNULL(es1.parent_destination, 'PLANT') as es1PlantCode	,
							s1.id	as shipperid,
							o1.serial as o1Serial					
					from		order_header oh1,
							edi_setups es1,
							destination d1,
							customer c1,
							shipper s1,
							shipper_detail sd1,
							object o1
					where	oh1.blanket_part = o1.part and
							es1.destination = oh1.destination and
							d1.destination = es1.destination and
							oh1.customer = c1.customer and 
							s1.id = o1.shipper and
							s1.id = sd1.shipper and
							sd1.part_original = o1.part and
							sd1.order_no = oh1.order_no) shipperorder on object.serial = o1serial
left join		FT.CommonSerialShipLog on object.serial = FT.CommonSerialShipLog.serial





GO
GRANT SELECT ON  [dbo].[vw_eei_CustomerLabel] TO [APPUser]
GO

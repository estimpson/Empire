SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[eeivw_form_picklist_elpaso]

as
SELECT (CASE WHEN order_header.standard_pack IS NULL or
order_header.standard_pack = 0 THEN part_inventory.standard_pack ELSE
order_header.standard_pack END) as std_pack,
         order_header.zone_code as order_header_zone_code,
         order_header.dock_code as order_header_dock_code,
         order_header.package_type as order_header_package_type,
         order_header.line_feed_code as order_header_line_feed_code,
         shipper.destination as shipper_destination,
         shipper.date_stamp as shipper_date_stamp,
         shipper.ship_via as shipper_ship_via,
         shipper.scheduled_ship_time as shipper_scheduled_ship_time,
         shipper_detail.customer_part as shipper_detail_customer_part, 
         shipper_detail.part as shipper_detail_part,
         shipper_detail.qty_required  shipper_detail_qty_required,
         shipper.id as shipper_id,
         part_inventory.primary_location as part_inventory_primary_location,
         part_online.on_hand as part_online_on_hand,
         destination.name as  destination_name,
         parameters.company_name as  parameters_company_name,
         shipper_detail.qty_original as   shipper_detail_qty_original,
         shipper_detail.qty_packed as shipper_detail_qty_packed,
         part_online.on_hand as partonlineonhand,
         (Select 	sum(o2.quantity)
          from		object o2
          where 	o2.part = shipper_detail.part_original and
                  		o2.status = 'A'  ) as app_qty,
         (Select 	sum(o2.quantity)
          from		object o2
          where 	o2.part = shipper_detail.part_original and
                  		o2.status <> 'A' ) as non_app_qty,
		Accum =IsNull ( (           select            sum ( O2.quantity )
                         from        object O2
                         where             O2.part = object.part and
                                     O2.serial <object.serial  and o2.location <> 'ELPASO'), 0 )+ quantity,
                         serial,
                         (ceiling(qty_original/(CASE WHEN order_header.standard_pack IS NULL or
order_header.standard_pack = 0 THEN part_inventory.standard_pack ELSE
order_header.standard_pack END) )*(CASE WHEN order_header.standard_pack IS NULL or
order_header.standard_pack = 0 THEN part_inventory.standard_pack ELSE
order_header.standard_pack END) ) as pull_qty,
                         object.location as object_location,
                         object.status as object_status,
									shipper.notes as shipper_notes,
					object.custom4 as ITNumber,
					shipper_detail.part_original as shipper_detail_part_original,
					shipper_detail.note as shipper_detail_note,
					object.parent_serial as object_parent_serial
    FROM order_header,
         shipper,
         shipper_detail,
         part_inventory,
         part_online,
         destination,
         parameters,
         object
   WHERE shipper.destination = destination.destination and
   			 part_online.part = shipper_detail.part and
         order_header.customer = shipper.customer  and
         shipper_detail.shipper = shipper.id and
         order_header.order_no = shipper_detail.order_no and
         shipper_detail.part = part_inventory.part  and
         object.part = shipper_detail.part_original and  object.location Like '%ELPASO%'
GO

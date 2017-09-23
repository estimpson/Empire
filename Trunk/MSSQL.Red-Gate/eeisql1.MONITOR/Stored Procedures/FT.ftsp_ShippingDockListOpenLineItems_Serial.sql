SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ShippingDockListOpenLineItems_Serial]
(	@ObjectSerial int)
as
select	shipper.id,
	shipper.destination,
	shipper.date_stamp,
	shipper.ship_via,
	shipper.bill_of_lading_number,
	shipper.staged_objs,
	shipper.plant,
	shipper.printed,
	shipper.customer,
	shipper.gross_weight,
	shipper.pro_number,
	shipper.status,
	shipper.notes,
	shipper.type,
	destination.name,
	shipper.net_weight,
	shipper.picklist_printed,
	shipper.invoice_number,
	shipper.scheduled_ship_time,
	shipper.cs_status,
	shipper_detail.part_original,
	shipper_detail.customer_part,
	shipper_detail.customer_po,
	shipper.staged_pallets,
	shipper_detail.boxes_staged,
	bill_of_lading.printed
from	shipper
	join shipper_detail on shipper.id = shipper_detail.shipper
	join customer_service_status on shipper.cs_status = customer_service_status.status_name and
		customer_service_status.status_type != 'C'
	join destination on shipper.destination = destination.destination
	left join bill_of_lading on shipper.bill_of_lading_number = bill_of_lading.bol_number
	left join destination_shipping on shipper.destination = destination_shipping.destination
where	shipper.status in ('O', 'S') and
	isnull (shipper.type, 'N') != 'R' and
	(	select	count (distinct part)
		from	object
		where	(	serial = @ObjectSerial or
				isnull (parent_serial, -1) = @ObjectSerial) and
			part != 'PALLET') =
		(	select	count (distinct part_original)
			from	shipper_detail
			where	shipper_detail.shipper = shipper.id and
				part_original in
				(	select	part
					from	object
					where	(	serial = @ObjectSerial or
						isnull (parent_serial, -1) = @ObjectSerial) and
						part != 'PALLET'))
order by
	shipper.date_stamp,
	shipper.destination,
	shipper.id,
	shipper_detail.part_original
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FT].[ftsp_ShippingDockListOpenShippers]
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
	shipper.staged_pallets,   
	bill_of_lading.printed  
from	shipper
	join customer_service_status on shipper.cs_status = customer_service_status.status_name and
		customer_service_status.status_type != 'C'
	join destination on shipper.destination = destination.destination
	left join bill_of_lading on shipper.bill_of_lading_number = bill_of_lading.bol_number
	left join destination_shipping on shipper.destination = destination_shipping.destination
where	shipper.status in ('O', 'S') and
	isnull (shipper.type, 'N') != 'R'
order by
	shipper.date_stamp,
	shipper.destination,
	shipper.id
GO

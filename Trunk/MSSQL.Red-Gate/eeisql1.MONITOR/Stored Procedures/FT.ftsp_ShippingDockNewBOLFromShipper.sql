SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ShippingDockNewBOLFromShipper]
(	@ShipperID int)
as
select	bol_number = 0,
	scac_transfer = convert(varchar (35), shipper.ship_via),
	scac_pickup = convert(varchar (35), isnull (shipper.bol_carrier, shipper.ship_via)),
	trans_mode = shipper.trans_mode,
	equipment_initial = convert(varchar (10), null),
	equipment_description = convert(varchar (10), null),
	status = 'O',
	printed = 'N',
	gross_weight = convert(numeric (7,2), shipper.gross_weight),
	net_weight = convert(numeric (7,2), shipper.net_weight),
	tare_weight = convert(numeric (7,2), shipper.tare_weight),
	destination = isnull(shipper.bol_ship_to, shipper.destination),
	lading_quantity = (select convert(numeric (20,6), count (o.serial)) from object o where shipper.id = o.shipper and parent_serial is null),
	total_boxes = convert(numeric (20,6), shipper.staged_objs)
from	shipper
	left outer join bill_of_lading on convert (int, shipper.bill_of_lading_number) = bill_of_lading.bol_number
where	shipper.id = @ShipperID
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_DirectShipProtransElpasoShipout]
(	@UserCode varchar (5),
	@ShipperID integer,
	@ShipDT datetime,
	@Plant varchar (20))
as
set nocount on
set ansi_warnings off
update	shipper
set	type = 'T',
	date_shipped = @ShipDT,
	status = 'C'
where	id = @ShipperID

insert	audit_trail
(	serial, date_stamp, type, part, quantity, remarks, operator, from_loc, to_loc, on_hand,
	status, shipper, unit, std_quantity, cost, plant,
	std_cost, user_defined_status, parent_serial, destination, show_on_shipper)
select	serial = object.serial,
	date_stamp = @ShipDT,
	type = 'T',
	part = object.part,
	quantity = object.quantity,
	remarks = 'Transfer',
	operator = @UserCode,
	from_loc = object.location,
	to_loc = @Plant,
	on_hand = (select sum (quantity) from object o2 where part = object.part and status = 'A'),
	status = object.status,
	shipper = @ShipperID,
	unit = object.unit_measure,
	std_quantity = object.std_quantity,
	cost = part_standard.cost_cum,
	plant = @Plant,
	std_cost = part_standard.cost_cum,
	user_defined_status = object.user_defined_status,
	parent_serial = object.parent_serial,
	destination = @Plant,
	show_on_shipper = object.show_on_shipper
from	object
	join shipper_detail on shipper_detail.shipper = @ShipperID and
		object.part = shipper_detail.part_original and
		isnull (object.suffix, -1) = isnull (shipper_detail.suffix, -1)
	join part_standard on object.part = part_standard.part
where	object.shipper = @ShipperID

update	object
set	shipper = null,
	location = @Plant,
	plant = @Plant,
	show_on_shipper = null
where	shipper = @ShipperID

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure  [FT].[ftsp_TransferShipperShipout]
(	@UserCode varchar (5),
	@ShipperID integer,
	@Plant varchar (20))
as
set nocount on
set ansi_warnings off
---------------------------------------------------------------------------------------
--	This procedure performs a ship out for a transfer shipper.

---------------------------------------------------------------------------------------

--	1.	Declare all the required local variables.
declare	@returnvalue	integer,
	@invoicenumber	integer,
	@cnt		integer,
	@bol		integer

	
update	shipper
set	type = 'T',
	date_shipped = GetDate (),
	status = 'C'
where	id = @ShipperID

if @@rowcount = 0
	Return -1

--	3.	Update shipper detail with date shipped and week no. and release date and no.


update	shipper_detail
set	date_shipped = shipper.date_shipped,
	week_no = datepart ( wk, shipper.date_shipped )
from	shipper_detail
	join shipper on shipper_detail.shipper = shipper.id
where	shipper = @ShipperID

--	4.	Generate audit trail records for inventory to be relieved.
insert	audit_trail
(	serial, date_stamp, type, part, quantity, remarks, operator, from_loc, to_loc, on_hand,
	status, shipper, unit, std_quantity, cost, plant,
	std_cost, user_defined_status, parent_serial, destination, show_on_shipper)
select	serial = object.serial,
	date_stamp = GetDate (),
	type = 'T',
	part = object.part,
	quantity = object.quantity,
	remarks = 'TranShip',
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


--		Adjust part online quantities for inventory.
update	part_online
set	on_hand = (
		select	Sum ( std_quantity )
		from	object
		where	part_online.part = object.part and
			object.status = 'A' )
from	part_online
	join shipper_detail on shipper_detail.shipper = @ShipperID and
		shipper_detail.part_original = part_online.part

--	8.	Relieve order requirements.
/*execute @returnvalue = msp_update_orders @ShipperID

if @returnvalue < 0
	return @returnvalue*/

--	9.	Close bill of lading.
select	@bol = bill_of_lading_number
from	shipper
where	id = @ShipperID

select	@cnt = count(1)
from	shipper
where	bill_of_lading_number = @bol and
	(isnull(status,'O') <> 'C' or isnull(status,'S') <> 'C')

if isnull(@cnt,0) = 0
	update	bill_of_lading
	set	status = 'C'
	from	bill_of_lading
		join shipper on shipper.id = @ShipperID and
		bill_of_lading.bol_number = shipper.bill_of_lading_number


select 0
return 0


GO

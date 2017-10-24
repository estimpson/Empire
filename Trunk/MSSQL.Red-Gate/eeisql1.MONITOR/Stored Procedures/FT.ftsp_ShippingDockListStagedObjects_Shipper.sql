SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ShippingDockListStagedObjects_Shipper]
(	@ShipperID int)
as
select	serial,
	part,
	quantity,
	unit_measure,
	std_quantity,
	parent_serial,
	shipper,
	type,
	package_type,
	weight,
	tare_weight,
	custom1,
	suffix,
	engineering_level
from	object
where	shipper = @ShipperID and
	show_on_shipper = 'Y'
GO

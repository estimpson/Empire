SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ShippingDockListShippersNeedingBOL_ShipTo]
(	@ShipTO varchar (20))
as
select	shipper.id,
	shipper.bill_of_lading_number,
	shipper.destination,
	shipper.ship_via,
	shipper.status,
	shipper.printed,
	shipper.picklist_printed
from	edi_setups
	join edi_setups PoolCodeEDI on edi_setups.pool_code = PoolCodeEDI.pool_code or
		edi_setups.destination = PoolCodeEDI.destination
	join shipper on PoolCodeEDI.destination = shipper.destination
where	edi_setups.destination = @ShipTO and
	isnull (shipper.bill_of_lading_number, 0) = 0 and
	status in ('O', 'S') and
	isnull (type, 'S') != 'R'
GO

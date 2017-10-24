SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ShippingDockGetShipperHeader_Shipper]
(	@ShipperID int)
as
select	shipper.id,
	shipper.destination,
	shipper.status,
	shipper.printed
from	shipper
where	id = @ShipperID
GO

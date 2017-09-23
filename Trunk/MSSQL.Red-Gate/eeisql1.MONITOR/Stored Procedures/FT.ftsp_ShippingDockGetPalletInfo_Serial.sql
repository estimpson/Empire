SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ShippingDockGetPalletInfo_Serial]
(	@PalletSerial int)
as
select object.serial,
        object.weight,
        object.custom1,
        object.tare_weight,
        object.lot,
        object.package_type,
	parameters.pallet_package_type,
	total_objects = (select count(1) from object where parent_serial = @PalletSerial)
from	object
	cross join parameters
where	object.serial = @PalletSerial
GO

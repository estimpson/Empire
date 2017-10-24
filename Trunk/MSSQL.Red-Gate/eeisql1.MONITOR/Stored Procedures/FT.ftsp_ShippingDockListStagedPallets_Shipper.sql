SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ShippingDockListStagedPallets_Shipper]
(	@ShipperID int)
as
select	pallet.serial,
	box.part,
	quantity = Sum (box.std_quantity),
	pallet.package_type,
	pallet_label = min (LineItems.pallet_label)
from	object pallet
	join object box on pallet.serial = box.parent_serial
	join FT.fn_ShippingDockListLineItem_Shipper (@ShipperID) LineItems on box.shipper = LineItems.shipper and
		box.part = LineItems.part_original
where	pallet.shipper = @ShipperID
group by
	pallet.serial,
	box.part,
	pallet.package_type
order by
	1, 2
GO

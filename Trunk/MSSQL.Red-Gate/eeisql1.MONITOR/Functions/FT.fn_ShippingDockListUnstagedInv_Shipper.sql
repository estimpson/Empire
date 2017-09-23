SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [FT].[fn_ShippingDockListUnstagedInv_Shipper]
(	@ShipperID int)
returns @Results table
(	serial integer primary key,
	part varchar(25),
	status char(1) null,
	quantity decimal(20,6) null,
	unit_measure varchar(2) null,
	std_quantity decimal(20,6) null,
	parent_serial integer null,
	shipper integer null,
	location varchar(10) null,
	note varchar(255) null,
	suffix integer null,
	origin varchar(20) null,
	engineering_level varchar(10) null,
	configurable char(1) null,
	unique (part, serial))
as
begin
	insert	@Results
	select	box.serial,
		box.part,
		box.status,
		box.quantity,
		box.unit_measure,
		box.std_quantity,
		box.parent_serial,
		box.shipper,
		box.location,
		box.note,
		box.suffix,
		box.origin,
		box.engineering_level,
		configurable
	from	shipper_detail
		join part_inventory on shipper_detail.part_original = part_inventory.part
		join object box on box.status = 'A' and
			shipper_detail.part_original = box.part and
			(	isnull (shipper_detail.suffix, 0) = isnull (box.suffix, 0) or
				isnull (part_inventory.configurable, 'N') = 'N')
	where	shipper_detail.shipper = @ShipperID

	insert	@Results
	select	pallet.serial,
		pallet.part,
		pallet.status,
		pallet.quantity,
		pallet.unit_measure,
		pallet.std_quantity,
		pallet.parent_serial,
		pallet.shipper,
		pallet.location,
		pallet.note,
		pallet.suffix,
		pallet.origin,
		pallet.engineering_level,
		'N'
	from	object pallet
	where	pallet.serial in (select parent_serial from @Results)
	
	return
end
GO

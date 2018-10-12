SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	view [dbo].[vw_eei_StdPack_Weight]

as
Select	part_inventory.part,
		part_vendor.vendor,
		COALESCE( part_vendor.vendor_standard_pack,part_inventory.standard_pack) as DefaultStdpack,
		part_inventory.standard_pack partStdPack,
		part_vendor.vendor_standard_pack VendorStdPack,
		unit_weight,
		standard_unit,
		COALESCE( part_vendor.vendor_standard_pack,part_inventory.standard_pack)*unit_weight as DefaultStdPackWeight,
		part_inventory.standard_pack*unit_weight partStdPackweight,
		part_vendor.vendor_standard_pack*unit_weight VendorStdPackweight,
		Address_1,
		Address_2,
		Address_3,
		City,
		State,
		Postal_code
from		part_inventory
left join	part_vendor on part_inventory.part = part_vendor.part
join		vendors	on part_vendor.vendor = vendors.vendor
join		[dbo].[addresses_clean] on vendors.address_id = [dbo].[addresses_clean].address_id
GO

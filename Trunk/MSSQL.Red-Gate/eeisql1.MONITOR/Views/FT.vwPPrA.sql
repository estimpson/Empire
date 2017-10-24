SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [FT].[vwPPrA]
(	Part,
	DefaultPO,
	DeliveryDW,
	FrozenWeeks,
	RoundingMethod,
	StandardPack,
	VendorLeadTime )
as
--	Description:
--	Get part purchasing information for automated parts.
select	Part = part_eecustom.part,
	DefaultPO = part_online.default_po_number,
	DeliveryDW = COALESCE(vendor_custom.custom4,2),
	FrozenWeeks = IsNull ( part_eecustom.weeks_to_freeze, 0 ),
	RoundingMethod = part_eecustom.generate_mr,
	StandardPack = IsNull ( part_vendor.vendor_standard_pack,
		(	select	min ( standard_pack )
			from	dbo.part_inventory
			where	part_vendor.part = part_inventory.part ) ),
	VendorLeadTime = part_vendor.lead_time
from	dbo.part_eecustom
	join dbo.part_online on part_eecustom.part = part_online.part
	join dbo.po_header on part_online.default_po_number = po_header.po_number
	join dbo.vendor_custom vendor_custom on po_header.vendor_code = vendor_custom.code
	join dbo.part_vendor on part_eecustom.part = part_vendor.part and
		po_header.vendor_code = part_vendor.vendor and
		IsNull ( part_vendor.vendor_standard_pack,
		(	select	min ( standard_pack )
			from	dbo.part_inventory
			where	part_vendor.part = part_inventory.part ) ) > 0
where	part_eecustom.auto_releases = 'Y' and
	part_eecustom.backdays > 0 and
	part_eecustom.generate_mr > '' and
	IsNull ( non_order_status, 'N' ) != 'Y' and
	part_online.default_po_number > 0 and
	po_header.blanket_part = part_eecustom.part 
	--AND	vendor_custom.custom4 > 0
GO

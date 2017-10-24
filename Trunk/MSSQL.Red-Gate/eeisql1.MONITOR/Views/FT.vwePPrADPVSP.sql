SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwePPrADPVSP]
(	Part,
	Description )
as
--	Description:
--	Exceptions are parts designated as Auto Releasing where the default
--	vendor's standard pack for this part is undefined or less than or equal
--	to zero.
select	Part = part_eecustom.part,
	Description = 'Default Vendor specified for part ' + part_eecustom.part + ' has an invalid standard pack defined for this part.  ' +
	(	case IsNull ( part_vendor.vendor_standard_pack, 1 )
			when 1 then '(undefined)'
			else '(' + convert ( varchar, part_vendor.vendor_standard_pack ) + ')'
		end )
from	dbo.part_eecustom
	join dbo.part_online on part_eecustom.part = part_online.part
	join dbo.po_header on part_online.default_po_number = po_header.po_number
	left outer join dbo.part_vendor on part_eecustom.part = part_vendor.part and
		po_header.vendor_code = part_vendor.vendor
where	part_eecustom.auto_releases = 'Y' and
	IsNull ( part_vendor.vendor_standard_pack, 0 ) <= 0
GO

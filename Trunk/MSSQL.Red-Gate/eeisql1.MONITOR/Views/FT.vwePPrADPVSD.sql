SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwePPrADPVSD]
(	Part,
	Description )
as
--	Description:
--	Exceptions are parts designated as Auto Releasing where the default
--	vendor's ship day for this part is undefined or invalid (non-numeric).
select	Part = part_eecustom.part,
	Description = 'Default Vendor specified for part ' + part_eecustom.part + ' has an invalid shipping day defined for this part.  ' +
	(	case IsNull ( Convert ( integer, vendor_custom.custom4 ), 1 )
			when 1 then '(undefined/invalid)'
			else '(' + convert ( varchar, vendor_custom.custom4 ) + ')'
		end )
from	dbo.part_eecustom
	join dbo.part_online on part_eecustom.part = part_online.part
	join dbo.po_header on part_online.default_po_number = po_header.po_number
	left outer join dbo.vendor_custom on po_header.vendor_code = vendor_custom.code and
		vendor_custom.custom4 not like '%[^1-9]%'
where	part_eecustom.auto_releases = 'Y' and
	not Convert ( integer, isNULL(vendor_custom.custom4,8) ) between 1 and 7
GO

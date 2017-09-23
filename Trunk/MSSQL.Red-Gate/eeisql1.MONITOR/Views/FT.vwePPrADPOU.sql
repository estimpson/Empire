SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwePPrADPOU]
(	Part,
	Description )
as
--	Description:
--	Exceptions are parts designated as Auto Releasing with no default PO
--	specified.
select	Part = part_eecustom.part,
	Description = 'Default PO unspecified for part ' + part_eecustom.part + '.  ' +
	(	case IsNull ( part_online.default_po_number, 1 )
			when 1 then '(undefined)'
			else '(' + convert ( varchar, part_online.default_po_number ) + ')'
		end )
from	dbo.part_eecustom
	join dbo.part_online on part_eecustom.part = part_online.part
where	part_eecustom.auto_releases = 'Y' and
	IsNull ( part_online.default_po_number, 0 ) <= 0
GO

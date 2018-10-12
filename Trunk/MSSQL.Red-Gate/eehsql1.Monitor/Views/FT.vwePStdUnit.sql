SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



Create view [FT].[vwePStdUnit]
(	Part,
	Description )
as
--	Description:
--	Exceptions are parts designated as Auto Releasing with undefined
--	standard unit.
select	Part = part_inventory.part,
	Description = 'The standard unit for part ' + part_eecustom.part + ' is undefined or invalid.  ' +
	(	case IsNull ( standard_unit, '' )
			when '' then '(undefined)'
			else '(' + standard_unit + ')'
		end )
from	dbo.part_inventory
JOIN
		dbo.part_eecustom on part_inventory.part = part_eecustom.part
where	part_eecustom.auto_releases in ('Y','A') and
	IsNull ( part_inventory.standard_unit, '' ) = ''


GO

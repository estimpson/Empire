SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwePPrARM]
(	Part,
	Description )
as
--	Description:
--	Exceptions are parts designated as Auto Releasing with undefined
--	rounding method.
select	Part = part_eecustom.part,
	Description = 'The rounding method for part ' + part_eecustom.part + ' is undefined or invalid.  ' +
	(	case IsNull ( generate_mr, '' )
			when '' then '(undefined)'
			else '(' + generate_mr + ')'
		end )
from	dbo.part_eecustom
where	part_eecustom.auto_releases = 'Y' and
	IsNull ( part_eecustom.generate_mr, '' ) = ''
GO

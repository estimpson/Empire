SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwePPrABD]
(	Part,
	Description )
as
--	Description:
--	Exceptions are parts designated as Auto Releasing with undefined or zero--	backdays.
select	Part = part_eecustom.part,
	Description = 'The backdays for part ' + part_eecustom.part + ' is null, negative, or zero.  ' +
	(	case IsNull ( backdays, 1 )
			when 1 then '(undefined)'
			else '(' + convert ( varchar, backdays ) + ')'
		end )
from	dbo.part_eecustom
where	part_eecustom.auto_releases = 'Y' and
	IsNull ( part_eecustom.backdays, -1 ) <= 0
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwePOH]
(	Part,
	Description )
as
--	Description:
--	Exceptions are part online records with invalid minimum on hand.
select	Part = part.part,
	Description = 'The minimum on hand for part ' + part.part + ' is negative.  ' +
	(	case IsNull ( part_online.min_onhand, 1 )
			when 1 then '(undefined)'
			else '(' + convert ( varchar, part_online.min_onhand ) + ')'
		end )
from	dbo.part
	join dbo.part_online on part.part = part_online.part
where	IsNull ( part_online.min_onhand, 0 ) < 0
GO

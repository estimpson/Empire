SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwePRt]
(	Part,
	Description )
as
--	Description:
--	Exceptions are part machine records with invalid parts per hour.
select	Part = part.part,
	Description = 'The parts per hour for part ' + part.part + ' is null, zero or negative.  ' +
	(	case IsNull ( part_machine.parts_per_hour, 1 )
			when 1 then '(undefined)'
			else '(' + convert ( varchar, part_machine.parts_per_hour ) + ')'
		end )
from	dbo.part
	join dbo.part_machine on part.part = part_machine.part
where	IsNull ( part_machine.parts_per_hour, 0 ) <= 0
GO

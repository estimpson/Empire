SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[ftvwePartRouter]
(	Part,
	Description )
as
--	Description:
--	Exceptions are part machine records with invalid parts per hour.
select	Part = Part.Part,
	Description = 'The parts per hour for part ' + Part.Part + ' is null, zero or negative.  ' +
	(	case IsNull ( min ( part_machine.parts_per_hour ), 1 )
			when 1 then '(undefined)'
			else '(' + convert ( varchar, min ( part_machine.parts_per_hour ) ) + ')'
		end )
from	FT.ftvwPart Part
	join dbo.part_machine part_machine on Part.Part = part_machine.part and
		part_machine.sequence = 1
where	IsNull ( part_machine.parts_per_hour, 0 ) <= 0
group by
	Part.Part
having	Count (1) = 1
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[ftvwePartRouterSeq]
(	Part,
	Description )
as
--	Description:
--	Exceptions are multiple part machine records with sequence = 1 for same part.
select	Part = Part.Part,
	Description = 'The part ' + Part.Part + ' has multiple machines designates as primary.  ' + '(' + convert ( varchar, count (1) ) + ')'
from	FT.ftvwPart Part
	join dbo.part_machine part_machine on Part.Part = part_machine.part and
		part_machine.sequence = 1
group by
	Part.Part
having	Count (1) > 1
GO

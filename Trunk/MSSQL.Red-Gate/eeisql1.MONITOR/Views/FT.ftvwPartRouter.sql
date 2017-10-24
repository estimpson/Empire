SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[ftvwPartRouter]
(	Part,
	BufferTime,
	RunRate,
	CrewSize )
as
--	Description:
--	Use part_machine view because it only pulls primary machine.
select	Part = Part.Part,
	BufferTime = min ( part_eecustom.backdays ),
	RunRate = min ( 1 / part_machine.parts_per_hour ),
	CrewSize = min ( part_machine.crew_size )
from	FT.ftvwPart Part
	left outer join dbo.part_eecustom part_eecustom on Part.Part = part_eecustom.part
	left outer join dbo.part_machine part_machine on Part.Part = part_machine.part and
		part_machine.sequence = 1 and
		part_machine.parts_per_hour > 0
group by
	Part.Part
having	Count (1) = 1
GO

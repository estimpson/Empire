SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwPRt]
(	Part,
	BufferTime,
	RunRate )
as
--	Description:
--	Use part_mfg view because it only pulls primary machine.
select	Part = part.part,
	BufferTime = part_eecustom.backdays,
	RunRate = 1 / part_mfg.parts_per_hour
from	dbo.part
	left outer join dbo.part_eecustom on part.part = part_eecustom.part
	left outer join dbo.part_mfg on part.part = part_mfg.part and
		part_mfg.parts_per_hour > 0
GO

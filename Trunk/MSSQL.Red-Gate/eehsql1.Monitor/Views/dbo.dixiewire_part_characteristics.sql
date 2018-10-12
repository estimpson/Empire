SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[dixiewire_part_characteristics] as
select	*
from	EEH.[dbo].[dixiewire_part_characteristics] with (READUNCOMMITTED)
GO

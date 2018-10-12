SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [dbo].[cost_part_import] as
select	*
from	EEH.[dbo].[cost_part_import] with (READUNCOMMITTED)


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEI_part_cost] as
select	*
from	EEH.[dbo].[EEI_part_cost] with (READUNCOMMITTED)
GO

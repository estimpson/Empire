SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[mvw_replenish] as
select	*
from	EEH.[dbo].[mvw_replenish] with (READUNCOMMITTED)
GO

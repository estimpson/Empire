SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Batavia862_ship_schedule] as
select	*
from	EEH.[dbo].[Batavia862_ship_schedule] with (READUNCOMMITTED)
GO

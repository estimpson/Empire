SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_Objects_Kanban] as
select	*
from	EEH.[dbo].[EEH_Objects_Kanban] with (READUNCOMMITTED)
GO

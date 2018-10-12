SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[kanban] as
select	*
from	EEH.[dbo].[kanban] with (READUNCOMMITTED)
GO

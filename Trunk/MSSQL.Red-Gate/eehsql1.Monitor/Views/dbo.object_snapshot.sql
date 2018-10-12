SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[object_snapshot] as
select	*
from	EEH.[dbo].[object_snapshot] with (READUNCOMMITTED)
GO

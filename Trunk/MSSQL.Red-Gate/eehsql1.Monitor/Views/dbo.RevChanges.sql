SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[RevChanges] as
select	*
from	EEH.[dbo].[RevChanges] with (READUNCOMMITTED)
GO

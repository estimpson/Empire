SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[PrintServers] as
select	*
from	EEH.[dbo].[PrintServers] with (READUNCOMMITTED)
GO

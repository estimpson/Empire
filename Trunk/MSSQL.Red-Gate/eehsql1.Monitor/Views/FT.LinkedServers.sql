SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[LinkedServers] as
select	*
from	EEH.[FT].[LinkedServers] with (READUNCOMMITTED)
GO

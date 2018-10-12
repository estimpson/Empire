SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[LatestBlanketRelease_nonEDI] as
select	*
from	EEH.[dbo].[LatestBlanketRelease_nonEDI] with (READUNCOMMITTED)
GO

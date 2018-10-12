SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[HighFabAuthorizations] as
select	*
from	EEH.[FT].[HighFabAuthorizations] with (READUNCOMMITTED)
GO

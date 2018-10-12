SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwFabAuthorizations] as
select	*
from	EEH.[FT].[vwFabAuthorizations] with (READUNCOMMITTED)
GO

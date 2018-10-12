SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwFabAuthorizations2] as
select	*
from	EEH.[FT].[vwFabAuthorizations2] with (READUNCOMMITTED)
GO

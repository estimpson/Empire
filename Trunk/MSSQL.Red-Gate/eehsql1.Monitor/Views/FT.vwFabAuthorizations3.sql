SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwFabAuthorizations3] as
select	*
from	EEH.[FT].[vwFabAuthorizations3] with (READUNCOMMITTED)
GO

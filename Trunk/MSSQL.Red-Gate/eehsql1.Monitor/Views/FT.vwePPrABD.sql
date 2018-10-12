SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwePPrABD] as
select	*
from	EEH.[FT].[vwePPrABD] with (READUNCOMMITTED)
GO

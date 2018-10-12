SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwePPrANOS] as
select	*
from	EEH.[FT].[vwePPrANOS] with (READUNCOMMITTED)
GO

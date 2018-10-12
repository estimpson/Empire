SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwePPrARM] as
select	*
from	EEH.[FT].[vwePPrARM] with (READUNCOMMITTED)
GO

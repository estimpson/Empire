SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwePPrADPOU] as
select	*
from	EEH.[FT].[vwePPrADPOU] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwePPrADPVSP] as
select	*
from	EEH.[FT].[vwePPrADPVSP] with (READUNCOMMITTED)
GO
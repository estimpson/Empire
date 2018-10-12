SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwShipLogRetransmitted] as
select	*
from	EEH.[FT].[vwShipLogRetransmitted] with (READUNCOMMITTED)
GO

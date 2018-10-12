SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwShipLogRetransmitX] as
select	*
from	EEH.[FT].[vwShipLogRetransmitX] with (READUNCOMMITTED)
GO

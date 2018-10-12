SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwShipLogRetransmit] as
select	*
from	EEH.[FT].[vwShipLogRetransmit] with (READUNCOMMITTED)
GO

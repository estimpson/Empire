SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwShipLogTransmit] as
select	*
from	EEH.[FT].[vwShipLogTransmit] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwShipLogTransmitted] as
select	*
from	EEH.[FT].[vwShipLogTransmitted] with (READUNCOMMITTED)
GO

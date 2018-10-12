SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwEEIShipLogX] as
select	*
from	EEH.[FT].[vwEEIShipLogX] with (READUNCOMMITTED)
GO

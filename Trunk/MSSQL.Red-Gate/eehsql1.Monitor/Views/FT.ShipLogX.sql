SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ShipLogX] as
select	*
from	EEH.[FT].[ShipLogX] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwShipLogFinalX] as
select	*
from	EEH.[FT].[vwShipLogFinalX] with (READUNCOMMITTED)
GO

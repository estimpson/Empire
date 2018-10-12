SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwShipLogUnprocessed] as
select	*
from	EEH.[FT].[vwShipLogUnprocessed] with (READUNCOMMITTED)
GO

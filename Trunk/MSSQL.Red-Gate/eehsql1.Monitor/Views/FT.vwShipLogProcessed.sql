SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwShipLogProcessed] as
select	*
from	EEH.[FT].[vwShipLogProcessed] with (READUNCOMMITTED)
GO

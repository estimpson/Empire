SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwShipLogFinal] as
select	*
from	EEH.[FT].[vwShipLogFinal] with (READUNCOMMITTED)
GO

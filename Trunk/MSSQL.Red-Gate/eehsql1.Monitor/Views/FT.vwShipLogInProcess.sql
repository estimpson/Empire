SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwShipLogInProcess] as
select	*
from	EEH.[FT].[vwShipLogInProcess] with (READUNCOMMITTED)
GO

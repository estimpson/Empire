SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ShipLog_bkup] as
select	*
from	EEH.[FT].[ShipLog_bkup] with (READUNCOMMITTED)
GO

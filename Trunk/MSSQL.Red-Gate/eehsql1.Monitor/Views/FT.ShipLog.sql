SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ShipLog] as
select	*
from	EEH.[FT].[ShipLog] with (READUNCOMMITTED)
GO

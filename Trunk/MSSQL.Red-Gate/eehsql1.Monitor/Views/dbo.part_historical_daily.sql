SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_historical_daily] as
select	*
from	EEH.[dbo].[part_historical_daily] with (READUNCOMMITTED)
GO

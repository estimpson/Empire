SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[object_historical_daily] as
select	*
from	EEH.[dbo].[object_historical_daily] with (READUNCOMMITTED)
GO

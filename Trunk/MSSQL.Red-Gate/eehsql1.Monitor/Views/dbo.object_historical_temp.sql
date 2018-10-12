SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[object_historical_temp] as
select	*
from	EEH.[dbo].[object_historical_temp] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[shop_floor_time_log] as
select	*
from	EEH.[dbo].[shop_floor_time_log] with (READUNCOMMITTED)
GO

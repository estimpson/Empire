SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[shop_floor_calendar] as
select	*
from	EEH.[dbo].[shop_floor_calendar] with (READUNCOMMITTED)
GO

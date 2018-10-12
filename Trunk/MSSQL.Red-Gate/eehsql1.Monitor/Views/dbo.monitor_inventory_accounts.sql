SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[monitor_inventory_accounts] as
select	*
from	EEH.[dbo].[monitor_inventory_accounts] with (READUNCOMMITTED)
GO

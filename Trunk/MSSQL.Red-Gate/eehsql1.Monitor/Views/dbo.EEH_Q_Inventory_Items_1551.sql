SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_Q_Inventory_Items_1551] as
select	*
from	EEH.[dbo].[EEH_Q_Inventory_Items_1551] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_Q_Inventory_Items] as
select	*
from	EEH.[dbo].[EEH_Q_Inventory_Items] with (READUNCOMMITTED)
GO

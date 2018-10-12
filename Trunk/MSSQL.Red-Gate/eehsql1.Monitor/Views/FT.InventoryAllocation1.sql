SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[InventoryAllocation1] as
select	*
from	EEH.[FT].[InventoryAllocation1] with (READUNCOMMITTED)
GO

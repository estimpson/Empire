SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEIPartInventory] as
select	*
from	EEH.[dbo].[EEIPartInventory] with (READUNCOMMITTED)
GO

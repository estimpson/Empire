SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[RawInventoryPlusWIPOnHand] as
select	*
from	EEH.[dbo].[RawInventoryPlusWIPOnHand] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[vwExpedite_Inventory] as
select	*
from	EEH.[HN].[vwExpedite_Inventory] with (READUNCOMMITTED)
GO

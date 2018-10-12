SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[vwCritical_Inventory] as
select	*
from	EEH.[HN].[vwCritical_Inventory] with (READUNCOMMITTED)
GO

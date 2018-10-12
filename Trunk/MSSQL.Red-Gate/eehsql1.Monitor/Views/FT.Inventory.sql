SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[Inventory] as
select	*
from	EEH.[FT].[Inventory] with (READUNCOMMITTED)
GO

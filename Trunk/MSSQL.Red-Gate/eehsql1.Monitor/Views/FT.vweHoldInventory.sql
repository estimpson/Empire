SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vweHoldInventory] as
select	*
from	EEH.[FT].[vweHoldInventory] with (READUNCOMMITTED)
GO

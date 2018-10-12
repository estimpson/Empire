SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[EndingOrders_TEMP] as
select	*
from	EEH.[FT].[EndingOrders_TEMP] with (READUNCOMMITTED)
GO

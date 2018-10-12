SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[commodity_prices] as
select	*
from	EEH.[dbo].[commodity_prices] with (READUNCOMMITTED)
GO

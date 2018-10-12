SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[SalesForecastRev] as
select	*
from	EEH.[dbo].[SalesForecastRev] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[SalesForecast] as
select	*
from	EEH.[dbo].[SalesForecast] with (READUNCOMMITTED)
GO

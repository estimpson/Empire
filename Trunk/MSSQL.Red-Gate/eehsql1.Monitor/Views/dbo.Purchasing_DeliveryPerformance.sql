SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Purchasing_DeliveryPerformance] as
select	*
from	EEH.[dbo].[Purchasing_DeliveryPerformance] with (READUNCOMMITTED)
GO

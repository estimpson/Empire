SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_fn_GetDeliveryPerformance] as
select	*
from	EEH.[dbo].[vw_fn_GetDeliveryPerformance] with (READUNCOMMITTED)
GO

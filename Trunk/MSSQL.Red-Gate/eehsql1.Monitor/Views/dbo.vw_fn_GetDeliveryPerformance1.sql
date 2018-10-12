SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_fn_GetDeliveryPerformance1] as
select	*
from	EEH.[dbo].[vw_fn_GetDeliveryPerformance1] with (READUNCOMMITTED)
GO

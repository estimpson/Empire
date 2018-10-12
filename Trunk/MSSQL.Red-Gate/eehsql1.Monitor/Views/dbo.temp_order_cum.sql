SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[temp_order_cum] as
select	*
from	EEH.[dbo].[temp_order_cum] with (READUNCOMMITTED)
GO

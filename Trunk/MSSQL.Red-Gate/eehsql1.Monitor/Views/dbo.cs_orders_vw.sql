SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cs_orders_vw] as
select	*
from	EEH.[dbo].[cs_orders_vw] with (READUNCOMMITTED)
GO

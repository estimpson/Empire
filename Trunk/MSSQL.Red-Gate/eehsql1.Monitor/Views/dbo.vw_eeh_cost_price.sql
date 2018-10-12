SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eeh_cost_price] as
select	*
from	EEH.[dbo].[vw_eeh_cost_price] with (READUNCOMMITTED)
GO

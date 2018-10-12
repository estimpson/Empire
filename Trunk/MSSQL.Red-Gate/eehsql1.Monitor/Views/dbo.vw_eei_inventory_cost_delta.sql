SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_inventory_cost_delta] as
select	*
from	EEH.[dbo].[vw_eei_inventory_cost_delta] with (READUNCOMMITTED)
GO

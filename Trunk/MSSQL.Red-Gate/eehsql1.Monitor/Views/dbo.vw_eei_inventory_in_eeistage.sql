SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_inventory_in_eeistage] as
select	*
from	EEH.[dbo].[vw_eei_inventory_in_eeistage] with (READUNCOMMITTED)
GO

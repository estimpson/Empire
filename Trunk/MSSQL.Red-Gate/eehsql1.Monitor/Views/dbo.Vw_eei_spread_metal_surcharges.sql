SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Vw_eei_spread_metal_surcharges] as
select	*
from	EEH.[dbo].[Vw_eei_spread_metal_surcharges] with (READUNCOMMITTED)
GO

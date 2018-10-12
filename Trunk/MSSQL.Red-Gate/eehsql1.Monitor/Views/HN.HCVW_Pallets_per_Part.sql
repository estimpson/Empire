SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[HCVW_Pallets_per_Part] as
select	*
from	EEH.[HN].[HCVW_Pallets_per_Part] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_eecustom_njb_setups] as
select	*
from	EEH.[dbo].[part_eecustom_njb_setups] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_eecustom_njb] as
select	*
from	EEH.[dbo].[part_eecustom_njb] with (READUNCOMMITTED)
GO

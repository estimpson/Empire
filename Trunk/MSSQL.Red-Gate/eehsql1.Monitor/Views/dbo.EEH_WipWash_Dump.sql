SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_WipWash_Dump] as
select	*
from	EEH.[dbo].[EEH_WipWash_Dump] with (READUNCOMMITTED)
GO

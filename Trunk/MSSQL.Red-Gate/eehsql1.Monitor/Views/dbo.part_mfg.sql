SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_mfg] as
select	*
from	EEH.[dbo].[part_mfg] with (READUNCOMMITTED)
GO

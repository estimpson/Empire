SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[mvw_machinelist] as
select	*
from	EEH.[dbo].[mvw_machinelist] with (READUNCOMMITTED)
GO

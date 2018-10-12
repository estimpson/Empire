SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_standard_snapshot] as
select	*
from	EEH.[dbo].[part_standard_snapshot] with (READUNCOMMITTED)
GO

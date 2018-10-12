SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_online] as
select	*
from	EEH.[dbo].[part_online] with (READUNCOMMITTED)
GO

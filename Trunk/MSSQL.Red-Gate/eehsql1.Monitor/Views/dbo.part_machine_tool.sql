SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_machine_tool] as
select	*
from	EEH.[dbo].[part_machine_tool] with (READUNCOMMITTED)
GO

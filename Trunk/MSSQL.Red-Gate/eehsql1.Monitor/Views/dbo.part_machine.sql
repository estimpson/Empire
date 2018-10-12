SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_machine] as
select	*
from	EEH.[dbo].[part_machine] with (READUNCOMMITTED)
GO

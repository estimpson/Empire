SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_tooling] as
select	*
from	EEH.[dbo].[part_tooling] with (READUNCOMMITTED)
GO

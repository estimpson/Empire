SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_revision] as
select	*
from	EEH.[dbo].[part_revision] with (READUNCOMMITTED)
GO

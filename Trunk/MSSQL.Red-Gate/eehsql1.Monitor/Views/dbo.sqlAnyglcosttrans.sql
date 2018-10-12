SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[sqlAnyglcosttrans] as
select	*
from	EEH.[dbo].[sqlAnyglcosttrans] with (READUNCOMMITTED)
GO

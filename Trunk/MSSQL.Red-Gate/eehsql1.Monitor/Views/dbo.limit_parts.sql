SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[limit_parts] as
select	*
from	EEH.[dbo].[limit_parts] with (READUNCOMMITTED)
GO

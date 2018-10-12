SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[alternative_parts] as
select	*
from	EEH.[dbo].[alternative_parts] with (READUNCOMMITTED)
GO

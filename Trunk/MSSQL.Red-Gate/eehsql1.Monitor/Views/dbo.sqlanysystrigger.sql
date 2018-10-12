SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[sqlanysystrigger] as
select	*
from	EEH.[dbo].[sqlanysystrigger] with (READUNCOMMITTED)
GO

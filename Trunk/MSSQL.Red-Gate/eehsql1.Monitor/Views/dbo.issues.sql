SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[issues] as
select	*
from	EEH.[dbo].[issues] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[department] as
select	*
from	EEH.[dbo].[department] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[company] as
select	*
from	EEH.[dbo].[company] with (READUNCOMMITTED)
GO

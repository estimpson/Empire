SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[team_data] as
select	*
from	EEH.[dbo].[team_data] with (READUNCOMMITTED)
GO

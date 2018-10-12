SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[sqlany_at_datestamps] as
select	*
from	EEH.[dbo].[sqlany_at_datestamps] with (READUNCOMMITTED)
GO

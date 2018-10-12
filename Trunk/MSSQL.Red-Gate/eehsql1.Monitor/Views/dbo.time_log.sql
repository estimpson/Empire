SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[time_log] as
select	*
from	EEH.[dbo].[time_log] with (READUNCOMMITTED)
GO

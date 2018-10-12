SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[MessageLog] as
select	*
from	EEH.[dbo].[MessageLog] with (READUNCOMMITTED)
GO

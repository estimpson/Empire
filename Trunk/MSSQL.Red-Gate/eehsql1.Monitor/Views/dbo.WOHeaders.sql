SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[WOHeaders] as
select	*
from	EEH.[dbo].[WOHeaders] with (READUNCOMMITTED)
GO

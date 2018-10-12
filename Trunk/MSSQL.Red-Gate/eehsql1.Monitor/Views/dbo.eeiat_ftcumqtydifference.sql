SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[eeiat_ftcumqtydifference] as
select	*
from	EEH.[dbo].[eeiat_ftcumqtydifference] with (READUNCOMMITTED)
GO

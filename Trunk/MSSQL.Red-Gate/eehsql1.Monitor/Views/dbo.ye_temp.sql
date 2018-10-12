SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ye_temp] as
select	*
from	EEH.[dbo].[ye_temp] with (READUNCOMMITTED)
GO

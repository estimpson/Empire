SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTZIds] as
select	*
from	EEH.[dbo].[FTZIds] with (READUNCOMMITTED)
GO

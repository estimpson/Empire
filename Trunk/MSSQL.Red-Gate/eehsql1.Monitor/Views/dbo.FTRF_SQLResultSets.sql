SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_SQLResultSets] as
select	*
from	EEH.[dbo].[FTRF_SQLResultSets] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_Users] as
select	*
from	EEH.[dbo].[FTRF_Users] with (READUNCOMMITTED)
GO

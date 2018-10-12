SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_ServerDSN] as
select	*
from	EEH.[dbo].[FTRF_ServerDSN] with (READUNCOMMITTED)
GO

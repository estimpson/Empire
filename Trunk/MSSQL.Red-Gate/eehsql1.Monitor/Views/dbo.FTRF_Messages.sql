SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_Messages] as
select	*
from	EEH.[dbo].[FTRF_Messages] with (READUNCOMMITTED)
GO

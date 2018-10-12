SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_Modules] as
select	*
from	EEH.[dbo].[FTRF_Modules] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_Elements] as
select	*
from	EEH.[dbo].[FTRF_Elements] with (READUNCOMMITTED)
GO

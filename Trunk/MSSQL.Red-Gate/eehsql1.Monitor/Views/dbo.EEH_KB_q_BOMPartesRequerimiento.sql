SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_KB_q_BOMPartesRequerimiento] as
select	*
from	EEH.[dbo].[EEH_KB_q_BOMPartesRequerimiento] with (READUNCOMMITTED)
GO

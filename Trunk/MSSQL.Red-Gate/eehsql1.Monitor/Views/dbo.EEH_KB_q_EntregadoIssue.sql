SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_KB_q_EntregadoIssue] as
select	*
from	EEH.[dbo].[EEH_KB_q_EntregadoIssue] with (READUNCOMMITTED)
GO

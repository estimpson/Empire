SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_BlanketReleaseForm_Dump] as
select	*
from	EEH.[dbo].[EEH_BlanketReleaseForm_Dump] with (READUNCOMMITTED)
GO

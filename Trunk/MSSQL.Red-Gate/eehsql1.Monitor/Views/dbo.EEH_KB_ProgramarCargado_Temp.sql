SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_KB_ProgramarCargado_Temp] as
select	*
from	EEH.[dbo].[EEH_KB_ProgramarCargado_Temp] with (READUNCOMMITTED)
GO

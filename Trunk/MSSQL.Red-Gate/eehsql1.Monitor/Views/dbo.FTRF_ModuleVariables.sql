SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_ModuleVariables] as
select	*
from	EEH.[dbo].[FTRF_ModuleVariables] with (READUNCOMMITTED)
GO

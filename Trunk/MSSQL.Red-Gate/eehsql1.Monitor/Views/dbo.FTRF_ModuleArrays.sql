SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_ModuleArrays] as
select	*
from	EEH.[dbo].[FTRF_ModuleArrays] with (READUNCOMMITTED)
GO

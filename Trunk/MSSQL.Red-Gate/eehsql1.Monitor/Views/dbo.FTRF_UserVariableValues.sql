SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_UserVariableValues] as
select	*
from	EEH.[dbo].[FTRF_UserVariableValues] with (READUNCOMMITTED)
GO

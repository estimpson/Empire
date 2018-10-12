SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_UserVariables] as
select	*
from	EEH.[dbo].[FTRF_UserVariables] with (READUNCOMMITTED)
GO

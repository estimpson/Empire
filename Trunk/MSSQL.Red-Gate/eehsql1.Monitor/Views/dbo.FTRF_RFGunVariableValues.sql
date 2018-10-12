SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_RFGunVariableValues] as
select	*
from	EEH.[dbo].[FTRF_RFGunVariableValues] with (READUNCOMMITTED)
GO

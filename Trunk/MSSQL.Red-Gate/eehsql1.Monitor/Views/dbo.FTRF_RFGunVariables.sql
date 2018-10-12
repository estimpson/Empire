SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_RFGunVariables] as
select	*
from	EEH.[dbo].[FTRF_RFGunVariables] with (READUNCOMMITTED)
GO

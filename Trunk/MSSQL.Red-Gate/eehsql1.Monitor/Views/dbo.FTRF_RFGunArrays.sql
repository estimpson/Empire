SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_RFGunArrays] as
select	*
from	EEH.[dbo].[FTRF_RFGunArrays] with (READUNCOMMITTED)
GO

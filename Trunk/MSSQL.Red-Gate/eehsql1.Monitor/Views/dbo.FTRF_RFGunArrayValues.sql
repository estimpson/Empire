SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_RFGunArrayValues] as
select	*
from	EEH.[dbo].[FTRF_RFGunArrayValues] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[FTRF_RFGuns] as
select	*
from	EEH.[dbo].[FTRF_RFGuns] with (READUNCOMMITTED)
GO

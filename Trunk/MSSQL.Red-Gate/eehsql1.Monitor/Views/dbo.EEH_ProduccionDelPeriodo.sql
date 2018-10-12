SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_ProduccionDelPeriodo] as
select	*
from	EEH.[dbo].[EEH_ProduccionDelPeriodo] with (READUNCOMMITTED)
GO

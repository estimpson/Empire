SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_ProduccionDelPeriodoRangoExtendido] as
select	*
from	EEH.[dbo].[EEH_ProduccionDelPeriodoRangoExtendido] with (READUNCOMMITTED)
GO

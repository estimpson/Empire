SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_accum_received] as
select	*
from	EEH.[dbo].[vw_eei_accum_received] with (READUNCOMMITTED)
GO

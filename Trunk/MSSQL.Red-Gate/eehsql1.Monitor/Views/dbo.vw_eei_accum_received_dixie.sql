SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_accum_received_dixie] as
select	*
from	EEH.[dbo].[vw_eei_accum_received_dixie] with (READUNCOMMITTED)
GO

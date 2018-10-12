SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_multiple_revs_shipped_within_60_days] as
select	*
from	EEH.[dbo].[vw_eei_multiple_revs_shipped_within_60_days] with (READUNCOMMITTED)
GO

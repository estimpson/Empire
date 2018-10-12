SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[eei_vw_projectedreceipts4weeks_all] as
select	*
from	EEH.[dbo].[eei_vw_projectedreceipts4weeks_all] with (READUNCOMMITTED)
GO

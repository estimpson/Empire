SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_apitems_surcharges] as
select	*
from	EEH.[dbo].[vw_eei_apitems_surcharges] with (READUNCOMMITTED)
GO

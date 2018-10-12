SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_ars_exception_poDetailnotonDefaultPO] as
select	*
from	EEH.[dbo].[vw_eei_ars_exception_poDetailnotonDefaultPO] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_apitems_with_surcharge] as
select	*
from	EEH.[dbo].[vw_eei_apitems_with_surcharge] with (READUNCOMMITTED)
GO

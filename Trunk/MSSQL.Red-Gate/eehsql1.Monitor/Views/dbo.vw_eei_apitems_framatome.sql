SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_apitems_framatome] as
select	*
from	EEH.[dbo].[vw_eei_apitems_framatome] with (READUNCOMMITTED)
GO

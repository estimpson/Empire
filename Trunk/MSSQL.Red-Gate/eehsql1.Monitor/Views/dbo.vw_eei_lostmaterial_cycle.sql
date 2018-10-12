SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_lostmaterial_cycle] as
select	*
from	EEH.[dbo].[vw_eei_lostmaterial_cycle] with (READUNCOMMITTED)
GO

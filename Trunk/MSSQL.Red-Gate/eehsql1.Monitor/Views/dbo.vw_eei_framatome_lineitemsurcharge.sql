SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_framatome_lineitemsurcharge] as
select	*
from	EEH.[dbo].[vw_eei_framatome_lineitemsurcharge] with (READUNCOMMITTED)
GO

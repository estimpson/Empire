SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_baseFinishedPart] as
select	*
from	EEH.[dbo].[vw_eei_baseFinishedPart] with (READUNCOMMITTED)
GO

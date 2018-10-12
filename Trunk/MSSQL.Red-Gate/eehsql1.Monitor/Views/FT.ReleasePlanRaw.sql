SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ReleasePlanRaw] as
select	*
from	EEH.[FT].[ReleasePlanRaw] with (READUNCOMMITTED)
GO

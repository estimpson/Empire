SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ReleasePlanPOs] as
select	*
from	EEH.[dbo].[ReleasePlanPOs] with (READUNCOMMITTED)
GO

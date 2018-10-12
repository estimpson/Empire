SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[CustomerReleasePlanRaw] as
select	*
from	EEH.[dbo].[CustomerReleasePlanRaw] with (READUNCOMMITTED)
GO

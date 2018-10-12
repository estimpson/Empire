SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[CurrentReleasePlan] as
select	*
from	EEH.[FT].[CurrentReleasePlan] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwFinalReleasePlan] as
select	*
from	EEH.[FT].[vwFinalReleasePlan] with (READUNCOMMITTED)
GO

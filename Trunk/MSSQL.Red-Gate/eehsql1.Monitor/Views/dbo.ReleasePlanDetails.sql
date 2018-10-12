SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ReleasePlanDetails] as
select	*
from	EEH.[dbo].[ReleasePlanDetails] with (READUNCOMMITTED)
GO

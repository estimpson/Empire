SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ReleasePlans] as
select	*
from	EEH.[FT].[ReleasePlans] with (READUNCOMMITTED)
GO

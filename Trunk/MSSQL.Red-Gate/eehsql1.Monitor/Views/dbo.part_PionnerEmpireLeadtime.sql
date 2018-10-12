SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_PionnerEmpireLeadtime] as
select	*
from	EEH.[dbo].[part_PionnerEmpireLeadtime] with (READUNCOMMITTED)
GO

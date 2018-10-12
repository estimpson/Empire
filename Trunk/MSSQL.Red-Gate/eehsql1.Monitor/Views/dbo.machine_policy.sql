SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[machine_policy] as
select	*
from	EEH.[dbo].[machine_policy] with (READUNCOMMITTED)
GO

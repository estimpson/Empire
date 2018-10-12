SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[sqlanymaster_prod_sched] as
select	*
from	EEH.[dbo].[sqlanymaster_prod_sched] with (READUNCOMMITTED)
GO

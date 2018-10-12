SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[downtime] as
select	*
from	EEH.[dbo].[downtime] with (READUNCOMMITTED)
GO

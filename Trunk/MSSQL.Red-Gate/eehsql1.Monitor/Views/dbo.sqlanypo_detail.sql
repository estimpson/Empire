SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[sqlanypo_detail] as
select	*
from	EEH.[dbo].[sqlanypo_detail] with (READUNCOMMITTED)
GO

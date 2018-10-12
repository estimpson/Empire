SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[issue_detail] as
select	*
from	EEH.[dbo].[issue_detail] with (READUNCOMMITTED)
GO

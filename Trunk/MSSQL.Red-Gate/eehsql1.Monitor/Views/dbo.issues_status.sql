SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[issues_status] as
select	*
from	EEH.[dbo].[issues_status] with (READUNCOMMITTED)
GO

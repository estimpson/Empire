SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[issues_category] as
select	*
from	EEH.[dbo].[issues_category] with (READUNCOMMITTED)
GO

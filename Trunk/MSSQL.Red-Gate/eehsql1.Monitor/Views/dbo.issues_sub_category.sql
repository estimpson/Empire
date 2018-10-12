SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[issues_sub_category] as
select	*
from	EEH.[dbo].[issues_sub_category] with (READUNCOMMITTED)
GO

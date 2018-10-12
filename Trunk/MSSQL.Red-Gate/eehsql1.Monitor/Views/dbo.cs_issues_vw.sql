SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cs_issues_vw] as
select	*
from	EEH.[dbo].[cs_issues_vw] with (READUNCOMMITTED)
GO

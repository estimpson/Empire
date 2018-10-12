SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[BF_rptScrap] as
select	*
from	EEH.[HN].[BF_rptScrap] with (READUNCOMMITTED)
GO

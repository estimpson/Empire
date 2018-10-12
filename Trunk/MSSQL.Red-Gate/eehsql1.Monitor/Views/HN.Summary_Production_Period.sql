SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[Summary_Production_Period] as
select	*
from	EEH.[HN].[Summary_Production_Period] with (READUNCOMMITTED)
GO

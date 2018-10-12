SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[MAT_Expediting_List] as
select	*
from	EEH.[HN].[MAT_Expediting_List] with (READUNCOMMITTED)
GO

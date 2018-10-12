SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[WFG_FormatLabelsLibrary] as
select	*
from	EEH.[dbo].[WFG_FormatLabelsLibrary] with (READUNCOMMITTED)
GO

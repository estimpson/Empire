SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEIReportLibrary] as
select	*
from	EEH.[dbo].[EEIReportLibrary] with (READUNCOMMITTED)
GO

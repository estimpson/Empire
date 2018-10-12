SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[report_library] as
select	*
from	EEH.[dbo].[report_library] with (READUNCOMMITTED)
GO

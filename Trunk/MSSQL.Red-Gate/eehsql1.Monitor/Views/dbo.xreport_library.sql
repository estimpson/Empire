SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[xreport_library] as
select	*
from	EEH.[dbo].[xreport_library] with (READUNCOMMITTED)
GO

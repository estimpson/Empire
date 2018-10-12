SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[requisition_project_number] as
select	*
from	EEH.[dbo].[requisition_project_number] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[requisition_group_project] as
select	*
from	EEH.[dbo].[requisition_group_project] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[requisition_account_project] as
select	*
from	EEH.[dbo].[requisition_account_project] with (READUNCOMMITTED)
GO

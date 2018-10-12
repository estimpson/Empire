SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[requisition_detail] as
select	*
from	EEH.[dbo].[requisition_detail] with (READUNCOMMITTED)
GO

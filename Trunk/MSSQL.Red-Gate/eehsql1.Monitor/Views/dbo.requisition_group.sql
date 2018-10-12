SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[requisition_group] as
select	*
from	EEH.[dbo].[requisition_group] with (READUNCOMMITTED)
GO

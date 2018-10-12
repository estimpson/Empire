SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[requisition_notes] as
select	*
from	EEH.[dbo].[requisition_notes] with (READUNCOMMITTED)
GO

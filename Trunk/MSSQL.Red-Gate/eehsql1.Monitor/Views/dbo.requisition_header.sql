SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[requisition_header] as
select	*
from	EEH.[dbo].[requisition_header] with (READUNCOMMITTED)
GO

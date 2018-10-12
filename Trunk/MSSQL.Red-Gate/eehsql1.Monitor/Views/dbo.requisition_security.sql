SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[requisition_security] as
select	*
from	EEH.[dbo].[requisition_security] with (READUNCOMMITTED)
GO

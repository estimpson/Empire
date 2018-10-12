SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[AuditTrail_26] as
select	*
from	EEH.[dbo].[AuditTrail_26] with (READUNCOMMITTED)
GO

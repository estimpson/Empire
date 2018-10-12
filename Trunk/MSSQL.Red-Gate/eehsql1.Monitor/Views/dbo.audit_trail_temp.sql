SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[audit_trail_temp] as
select	*
from	EEH.[dbo].[audit_trail_temp] with (READUNCOMMITTED)
GO

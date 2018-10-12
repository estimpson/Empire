SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_audit_trail_in_out] as
select	*
from	EEH.[dbo].[vw_audit_trail_in_out] with (READUNCOMMITTED)
GO

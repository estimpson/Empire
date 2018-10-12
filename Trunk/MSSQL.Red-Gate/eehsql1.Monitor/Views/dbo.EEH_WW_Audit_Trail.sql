SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_WW_Audit_Trail] as
select	*
from	EEH.[dbo].[EEH_WW_Audit_Trail] with (READUNCOMMITTED)
GO

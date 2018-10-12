SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cs_contact_call_log_vw] as
select	*
from	EEH.[dbo].[cs_contact_call_log_vw] with (READUNCOMMITTED)
GO

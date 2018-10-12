SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[contact_call_log] as
select	*
from	EEH.[dbo].[contact_call_log] with (READUNCOMMITTED)
GO

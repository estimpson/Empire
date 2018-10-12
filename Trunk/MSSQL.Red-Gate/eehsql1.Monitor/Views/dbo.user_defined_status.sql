SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[user_defined_status] as
select	*
from	EEH.[dbo].[user_defined_status] with (READUNCOMMITTED)
GO

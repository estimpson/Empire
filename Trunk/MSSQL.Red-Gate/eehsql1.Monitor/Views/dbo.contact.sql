SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[contact] as
select	*
from	EEH.[dbo].[contact] with (READUNCOMMITTED)
GO

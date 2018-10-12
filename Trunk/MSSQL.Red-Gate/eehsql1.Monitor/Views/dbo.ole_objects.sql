SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ole_objects] as
select	*
from	EEH.[dbo].[ole_objects] with (READUNCOMMITTED)
GO

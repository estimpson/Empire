SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dimensions] as
select	*
from	EEH.[dbo].[dimensions] with (READUNCOMMITTED)
GO

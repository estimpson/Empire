SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[X] as
select	*
from	EEH.[dbo].[X] with (READUNCOMMITTED)
GO

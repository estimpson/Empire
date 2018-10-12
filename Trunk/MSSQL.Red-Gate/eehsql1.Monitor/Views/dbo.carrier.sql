SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[carrier] as
select	*
from	EEH.[dbo].[carrier] with (READUNCOMMITTED)
GO

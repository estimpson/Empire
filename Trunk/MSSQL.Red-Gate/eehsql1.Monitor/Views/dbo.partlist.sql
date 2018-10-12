SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[partlist] as
select	*
from	EEH.[dbo].[partlist] with (READUNCOMMITTED)
GO

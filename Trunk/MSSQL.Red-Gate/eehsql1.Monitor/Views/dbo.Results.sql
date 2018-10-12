SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Results] as
select	*
from	EEH.[dbo].[Results] with (READUNCOMMITTED)
GO

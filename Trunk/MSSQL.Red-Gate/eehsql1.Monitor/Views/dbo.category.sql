SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[category] as
select	*
from	EEH.[dbo].[category] with (READUNCOMMITTED)
GO

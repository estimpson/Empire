SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[activity_router] as
select	*
from	EEH.[dbo].[activity_router] with (READUNCOMMITTED)
GO

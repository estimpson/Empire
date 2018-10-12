SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Batavia862_container] as
select	*
from	EEH.[dbo].[Batavia862_container] with (READUNCOMMITTED)
GO

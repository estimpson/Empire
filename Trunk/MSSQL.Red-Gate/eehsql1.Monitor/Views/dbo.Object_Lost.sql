SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Object_Lost] as
select	*
from	EEH.[dbo].[Object_Lost] with (READUNCOMMITTED)
GO

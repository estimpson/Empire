SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[PartRevCompound] as
select	*
from	EEH.[dbo].[PartRevCompound] with (READUNCOMMITTED)
GO

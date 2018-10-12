SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[plant_part] as
select	*
from	EEH.[dbo].[plant_part] with (READUNCOMMITTED)
GO

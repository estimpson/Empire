SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[location_limits] as
select	*
from	EEH.[dbo].[location_limits] with (READUNCOMMITTED)
GO

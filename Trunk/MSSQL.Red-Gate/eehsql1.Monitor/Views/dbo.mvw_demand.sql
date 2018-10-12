SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[mvw_demand] as
select	*
from	EEH.[dbo].[mvw_demand] with (READUNCOMMITTED)
GO

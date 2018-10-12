SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[region_code] as
select	*
from	EEH.[dbo].[region_code] with (READUNCOMMITTED)
GO

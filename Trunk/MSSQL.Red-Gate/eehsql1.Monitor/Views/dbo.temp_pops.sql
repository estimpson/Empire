SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[temp_pops] as
select	*
from	EEH.[dbo].[temp_pops] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[temp_bom_stack] as
select	*
from	EEH.[dbo].[temp_bom_stack] with (READUNCOMMITTED)
GO

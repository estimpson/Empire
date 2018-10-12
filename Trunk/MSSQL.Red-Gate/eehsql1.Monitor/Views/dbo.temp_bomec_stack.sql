SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[temp_bomec_stack] as
select	*
from	EEH.[dbo].[temp_bomec_stack] with (READUNCOMMITTED)
GO

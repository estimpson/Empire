SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[mvw_resource_shift_list] as
select	*
from	EEH.[dbo].[mvw_resource_shift_list] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[gt_comp_list] as
select	*
from	EEH.[dbo].[gt_comp_list] with (READUNCOMMITTED)
GO

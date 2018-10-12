SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_part_vendor_matrix] as
select	*
from	EEH.[dbo].[EEH_part_vendor_matrix] with (READUNCOMMITTED)
GO

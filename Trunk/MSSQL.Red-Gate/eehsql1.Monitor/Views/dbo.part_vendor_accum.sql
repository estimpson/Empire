SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_vendor_accum] as
select	*
from	EEH.[dbo].[part_vendor_accum] with (READUNCOMMITTED)
GO

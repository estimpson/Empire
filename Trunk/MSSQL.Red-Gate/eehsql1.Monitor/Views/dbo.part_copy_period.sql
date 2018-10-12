SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_copy_period] as
select	*
from	EEH.[dbo].[part_copy_period] with (READUNCOMMITTED)
GO

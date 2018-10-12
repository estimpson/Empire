SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_standard_copy] as
select	*
from	EEH.[dbo].[part_standard_copy] with (READUNCOMMITTED)
GO

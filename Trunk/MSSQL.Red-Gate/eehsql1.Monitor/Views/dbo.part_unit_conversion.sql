SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_unit_conversion] as
select	*
from	EEH.[dbo].[part_unit_conversion] with (READUNCOMMITTED)
GO

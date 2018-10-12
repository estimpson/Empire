SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ars_part_intialize] as
select	*
from	EEH.[dbo].[ars_part_intialize] with (READUNCOMMITTED)
GO

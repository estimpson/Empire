SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_description_short] as
select	*
from	EEH.[dbo].[part_description_short] with (READUNCOMMITTED)
GO

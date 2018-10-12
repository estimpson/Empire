SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_location] as
select	*
from	EEH.[dbo].[part_location] with (READUNCOMMITTED)
GO

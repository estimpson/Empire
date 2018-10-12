SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_packaging] as
select	*
from	EEH.[dbo].[part_packaging] with (READUNCOMMITTED)
GO

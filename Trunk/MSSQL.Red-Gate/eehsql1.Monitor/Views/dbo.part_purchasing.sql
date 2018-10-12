SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_purchasing] as
select	*
from	EEH.[dbo].[part_purchasing] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[destination_a1] as
select	*
from	EEH.[dbo].[destination_a1] with (READUNCOMMITTED)
GO

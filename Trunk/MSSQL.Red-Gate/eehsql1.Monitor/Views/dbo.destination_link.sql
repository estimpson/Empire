SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[destination_link] as
select	*
from	EEH.[dbo].[destination_link] with (READUNCOMMITTED)
GO

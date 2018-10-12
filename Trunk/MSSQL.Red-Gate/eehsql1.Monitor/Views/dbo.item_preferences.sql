SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[item_preferences] as
select	*
from	EEH.[dbo].[item_preferences] with (READUNCOMMITTED)
GO

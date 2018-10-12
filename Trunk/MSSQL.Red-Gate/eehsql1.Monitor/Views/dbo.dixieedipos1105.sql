SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[dixieedipos1105] as
select	*
from	EEH.[dbo].[dixieedipos1105] with (READUNCOMMITTED)
GO

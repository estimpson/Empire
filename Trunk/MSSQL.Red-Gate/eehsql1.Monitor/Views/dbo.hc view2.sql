SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[hc view2] as
select	*
from	EEH.[dbo].[hc view2] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[group_technology] as
select	*
from	EEH.[dbo].[group_technology] with (READUNCOMMITTED)
GO

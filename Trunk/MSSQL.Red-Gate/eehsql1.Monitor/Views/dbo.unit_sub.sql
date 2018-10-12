SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[unit_sub] as
select	*
from	EEH.[dbo].[unit_sub] with (READUNCOMMITTED)
GO

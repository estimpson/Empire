SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[m_in_ship_schedule] as
select	*
from	EEH.[dbo].[m_in_ship_schedule] with (READUNCOMMITTED)
GO

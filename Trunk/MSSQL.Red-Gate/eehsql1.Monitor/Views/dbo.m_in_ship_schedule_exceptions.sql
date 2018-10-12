SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[m_in_ship_schedule_exceptions] as
select	*
from	EEH.[dbo].[m_in_ship_schedule_exceptions] with (READUNCOMMITTED)
GO

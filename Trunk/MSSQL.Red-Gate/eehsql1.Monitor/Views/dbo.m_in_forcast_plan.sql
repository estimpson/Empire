SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[m_in_forcast_plan] as
select	*
from	EEH.[dbo].[m_in_forcast_plan] with (READUNCOMMITTED)
GO

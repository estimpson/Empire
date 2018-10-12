SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cs_ship_history_summary_vw] as
select	*
from	EEH.[dbo].[cs_ship_history_summary_vw] with (READUNCOMMITTED)
GO

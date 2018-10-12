SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cs_ship_history_detail_vw] as
select	*
from	EEH.[dbo].[cs_ship_history_detail_vw] with (READUNCOMMITTED)
GO

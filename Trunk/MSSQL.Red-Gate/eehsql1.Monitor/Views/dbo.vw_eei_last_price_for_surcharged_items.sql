SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_last_price_for_surcharged_items] as
select	*
from	EEH.[dbo].[vw_eei_last_price_for_surcharged_items] with (READUNCOMMITTED)
GO

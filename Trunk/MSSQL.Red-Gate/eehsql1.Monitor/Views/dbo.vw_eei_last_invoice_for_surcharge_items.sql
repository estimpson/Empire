SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_last_invoice_for_surcharge_items] as
select	*
from	EEH.[dbo].[vw_eei_last_invoice_for_surcharge_items] with (READUNCOMMITTED)
GO

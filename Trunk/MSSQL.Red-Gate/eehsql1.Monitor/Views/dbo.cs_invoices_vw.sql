SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cs_invoices_vw] as
select	*
from	EEH.[dbo].[cs_invoices_vw] with (READUNCOMMITTED)
GO

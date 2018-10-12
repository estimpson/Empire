SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ars_po_initialize] as
select	*
from	EEH.[dbo].[ars_po_initialize] with (READUNCOMMITTED)
GO

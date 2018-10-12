SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_po_temp_hc] as
select	*
from	EEH.[dbo].[edi_po_temp_hc] with (READUNCOMMITTED)
GO

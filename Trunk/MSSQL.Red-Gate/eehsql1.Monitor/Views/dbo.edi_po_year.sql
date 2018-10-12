SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_po_year] as
select	*
from	EEH.[dbo].[edi_po_year] with (READUNCOMMITTED)
GO

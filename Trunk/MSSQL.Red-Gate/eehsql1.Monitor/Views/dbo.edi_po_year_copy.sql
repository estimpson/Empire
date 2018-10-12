SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_po_year_copy] as
select	*
from	EEH.[dbo].[edi_po_year_copy] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_po_high_auth] as
select	*
from	EEH.[dbo].[edi_po_high_auth] with (READUNCOMMITTED)
GO

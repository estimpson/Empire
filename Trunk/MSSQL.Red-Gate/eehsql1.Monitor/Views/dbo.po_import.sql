SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[po_import] as
select	*
from	EEH.[dbo].[po_import] with (READUNCOMMITTED)
GO

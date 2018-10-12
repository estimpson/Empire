SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[po_detail_fromSQLServer] as
select	*
from	EEH.[dbo].[po_detail_fromSQLServer] with (READUNCOMMITTED)
GO

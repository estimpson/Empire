SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[po_sent] as
select	*
from	EEH.[dbo].[po_sent] with (READUNCOMMITTED)
GO

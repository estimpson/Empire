SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[po_receiver_items_copy_20061031] as
select	*
from	EEH.[dbo].[po_receiver_items_copy_20061031] with (READUNCOMMITTED)
GO

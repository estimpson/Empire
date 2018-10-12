SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[po_receiver_items_copy_period] as
select	*
from	EEH.[dbo].[po_receiver_items_copy_period] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[po_receiver_items_historical] as
select	*
from	EEH.[dbo].[po_receiver_items_historical] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ReceiptTotal] as
select	*
from	EEH.[dbo].[ReceiptTotal] with (READUNCOMMITTED)
GO

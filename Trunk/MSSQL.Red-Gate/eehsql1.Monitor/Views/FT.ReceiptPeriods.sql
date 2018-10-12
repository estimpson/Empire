SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ReceiptPeriods] as
select	*
from	EEH.[FT].[ReceiptPeriods] with (READUNCOMMITTED)
GO

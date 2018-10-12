SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ReceiptReversals] as
select	*
from	EEH.[FT].[ReceiptReversals] with (READUNCOMMITTED)
GO

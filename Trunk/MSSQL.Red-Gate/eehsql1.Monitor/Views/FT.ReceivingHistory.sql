SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ReceivingHistory] as
select	*
from	EEH.[FT].[ReceivingHistory] with (READUNCOMMITTED)
GO

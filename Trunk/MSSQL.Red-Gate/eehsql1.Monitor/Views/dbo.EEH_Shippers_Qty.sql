SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_Shippers_Qty] as
select	*
from	EEH.[dbo].[EEH_Shippers_Qty] with (READUNCOMMITTED)
GO

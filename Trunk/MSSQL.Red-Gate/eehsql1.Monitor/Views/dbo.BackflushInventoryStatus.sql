SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[BackflushInventoryStatus] as
select	*
from	EEH.[dbo].[BackflushInventoryStatus] with (READUNCOMMITTED)
GO

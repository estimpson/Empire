SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[eei_mitsubishi_inventory] as
select	*
from	EEH.[dbo].[eei_mitsubishi_inventory] with (READUNCOMMITTED)
GO

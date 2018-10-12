SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[destination_shipping] as
select	*
from	EEH.[dbo].[destination_shipping] with (READUNCOMMITTED)
GO

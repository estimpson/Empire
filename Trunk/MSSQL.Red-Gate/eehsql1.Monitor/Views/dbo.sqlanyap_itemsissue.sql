SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[sqlanyap_itemsissue] as
select	*
from	EEH.[dbo].[sqlanyap_itemsissue] with (READUNCOMMITTED)
GO

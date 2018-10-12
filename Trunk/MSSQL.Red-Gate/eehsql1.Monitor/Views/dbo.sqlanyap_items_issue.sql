SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[sqlanyap_items_issue] as
select	*
from	EEH.[dbo].[sqlanyap_items_issue] with (READUNCOMMITTED)
GO

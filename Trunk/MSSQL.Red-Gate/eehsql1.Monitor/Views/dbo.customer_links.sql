SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[customer_links] as
select	*
from	EEH.[dbo].[customer_links] with (READUNCOMMITTED)
GO

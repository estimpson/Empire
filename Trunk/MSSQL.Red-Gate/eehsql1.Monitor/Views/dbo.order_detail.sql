SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[order_detail] as
select	*
from	EEH.[dbo].[order_detail] with (READUNCOMMITTED)
GO

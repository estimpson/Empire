SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[order_detail_inserted] as
select	*
from	EEH.[dbo].[order_detail_inserted] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[order_header] as
select	*
from	EEH.[dbo].[order_header] with (READUNCOMMITTED)
GO

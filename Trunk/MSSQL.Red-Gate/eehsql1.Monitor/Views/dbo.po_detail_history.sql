SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[po_detail_history] as
select	*
from	EEH.[dbo].[po_detail_history] with (READUNCOMMITTED)
GO

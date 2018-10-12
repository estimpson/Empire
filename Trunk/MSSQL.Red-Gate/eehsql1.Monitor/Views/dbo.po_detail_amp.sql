SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[po_detail_amp] as
select	*
from	EEH.[dbo].[po_detail_amp] with (READUNCOMMITTED)
GO

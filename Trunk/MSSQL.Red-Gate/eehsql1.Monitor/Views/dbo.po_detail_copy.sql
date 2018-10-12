SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[po_detail_copy] as
select	*
from	EEH.[dbo].[po_detail_copy] with (READUNCOMMITTED)
GO

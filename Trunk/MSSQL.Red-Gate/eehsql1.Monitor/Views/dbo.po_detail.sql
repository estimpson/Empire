SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[po_detail] as
select	*
from	EEH.[dbo].[po_detail] with (READUNCOMMITTED)
GO

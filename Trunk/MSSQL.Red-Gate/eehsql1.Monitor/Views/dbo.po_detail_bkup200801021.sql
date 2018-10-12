SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[po_detail_bkup200801021] as
select	*
from	EEH.[dbo].[po_detail_bkup200801021] with (READUNCOMMITTED)
GO

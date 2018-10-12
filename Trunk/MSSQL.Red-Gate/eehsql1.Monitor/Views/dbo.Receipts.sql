SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Receipts] as
select	*
from	EEH.[dbo].[Receipts] with (READUNCOMMITTED)
GO

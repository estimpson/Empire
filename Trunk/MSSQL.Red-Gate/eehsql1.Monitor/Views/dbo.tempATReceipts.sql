SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[tempATReceipts] as
select	*
from	EEH.[dbo].[tempATReceipts] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[UnauthReceipts] as
select	*
from	EEH.[dbo].[UnauthReceipts] with (READUNCOMMITTED)
GO

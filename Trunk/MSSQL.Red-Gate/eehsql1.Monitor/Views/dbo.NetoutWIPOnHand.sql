SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[NetoutWIPOnHand] as
select	*
from	EEH.[dbo].[NetoutWIPOnHand] with (READUNCOMMITTED)
GO

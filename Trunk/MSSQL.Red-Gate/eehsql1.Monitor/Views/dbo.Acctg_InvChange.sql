SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Acctg_InvChange] as
select	*
from	EEH.[dbo].[Acctg_InvChange] with (READUNCOMMITTED)
GO

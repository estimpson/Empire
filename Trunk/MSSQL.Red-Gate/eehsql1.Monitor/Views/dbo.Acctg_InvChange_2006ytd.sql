SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Acctg_InvChange_2006ytd] as
select	*
from	EEH.[dbo].[Acctg_InvChange_2006ytd] with (READUNCOMMITTED)
GO

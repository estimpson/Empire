SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[Acctg_ActivityComparison] as
select	*
from	EEH.[dbo].[Acctg_ActivityComparison] with (READUNCOMMITTED)
GO

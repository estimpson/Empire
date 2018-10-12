SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Acctg_Rollup_Analysis] as
select	*
from	EEH.[dbo].[Acctg_Rollup_Analysis] with (READUNCOMMITTED)
GO

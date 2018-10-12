SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[SelectedEmpowerTransactions] as
select	*
from	EEH.[dbo].[SelectedEmpowerTransactions] with (READUNCOMMITTED)
GO

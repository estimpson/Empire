SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_KB_BillMaterialData_Tranfer] as
select	*
from	EEH.[dbo].[EEH_KB_BillMaterialData_Tranfer] with (READUNCOMMITTED)
GO

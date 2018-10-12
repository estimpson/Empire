SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[KB_BillMaterialData_Transfer] as
select	*
from	EEH.[dbo].[KB_BillMaterialData_Transfer] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[KB_BillMaterialData_Issue] as
select	*
from	EEH.[dbo].[KB_BillMaterialData_Issue] with (READUNCOMMITTED)
GO

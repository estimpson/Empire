SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eeiMaterialCostBasePart] as
select	*
from	EEH.[dbo].[vw_eeiMaterialCostBasePart] with (READUNCOMMITTED)
GO

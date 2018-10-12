SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE view [dbo].[cost_part_import_staging] as
select	*
from	EEH.[dbo].[cost_part_import_staging] with (READUNCOMMITTED)




GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vwBackflushMaterialUsage] as
select	*
from	EEH.[dbo].[vwBackflushMaterialUsage] with (READUNCOMMITTED)
GO

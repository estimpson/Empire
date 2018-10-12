SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[sqlAnysysindexes] as
select	*
from	EEH.[dbo].[sqlAnysysindexes] with (READUNCOMMITTED)
GO

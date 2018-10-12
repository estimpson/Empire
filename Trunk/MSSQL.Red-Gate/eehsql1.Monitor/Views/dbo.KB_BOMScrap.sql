SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[KB_BOMScrap] as
select	*
from	EEH.[dbo].[KB_BOMScrap] with (READUNCOMMITTED)
GO

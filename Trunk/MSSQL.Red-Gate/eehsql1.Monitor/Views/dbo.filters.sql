SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[filters] as
select	*
from	EEH.[dbo].[filters] with (READUNCOMMITTED)
GO

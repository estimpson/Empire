SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[pbcatedt] as
select	*
from	EEH.[dbo].[pbcatedt] with (READUNCOMMITTED)
GO

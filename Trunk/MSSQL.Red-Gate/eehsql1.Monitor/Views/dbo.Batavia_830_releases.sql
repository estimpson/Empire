SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Batavia_830_releases] as
select	*
from	EEH.[dbo].[Batavia_830_releases] with (READUNCOMMITTED)
GO

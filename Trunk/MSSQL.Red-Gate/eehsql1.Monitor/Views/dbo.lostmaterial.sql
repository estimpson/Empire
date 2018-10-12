SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[lostmaterial] as
select	*
from	EEH.[dbo].[lostmaterial] with (READUNCOMMITTED)
GO

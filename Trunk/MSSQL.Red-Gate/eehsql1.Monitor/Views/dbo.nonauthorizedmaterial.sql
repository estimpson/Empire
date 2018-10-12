SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[nonauthorizedmaterial] as
select	*
from	EEH.[dbo].[nonauthorizedmaterial] with (READUNCOMMITTED)
GO

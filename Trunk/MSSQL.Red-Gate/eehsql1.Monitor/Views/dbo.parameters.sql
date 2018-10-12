SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[parameters] as
select	*
from	EEH.[dbo].[parameters] with (READUNCOMMITTED)
GO

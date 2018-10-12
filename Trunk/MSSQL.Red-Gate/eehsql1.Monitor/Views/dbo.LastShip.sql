SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[LastShip] as
select	*
from	EEH.[dbo].[LastShip] with (READUNCOMMITTED)
GO

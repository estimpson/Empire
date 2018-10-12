SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vweeiBOM] as
select	*
from	EEH.[dbo].[vweeiBOM] with (READUNCOMMITTED)
GO

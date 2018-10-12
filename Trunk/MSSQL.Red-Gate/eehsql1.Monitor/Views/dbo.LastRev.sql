SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[LastRev] as
select	*
from	EEH.[dbo].[LastRev] with (READUNCOMMITTED)
GO

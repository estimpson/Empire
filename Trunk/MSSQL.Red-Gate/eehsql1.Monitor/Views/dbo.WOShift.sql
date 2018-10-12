SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[WOShift] as
select	*
from	EEH.[dbo].[WOShift] with (READUNCOMMITTED)
GO

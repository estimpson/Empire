SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[netoutdump] as
select	*
from	EEH.[dbo].[netoutdump] with (READUNCOMMITTED)
GO

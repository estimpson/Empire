SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[WODetailsNew] as
select	*
from	EEH.[dbo].[WODetailsNew] with (READUNCOMMITTED)
GO

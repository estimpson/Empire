SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[WOHeadersNew] as
select	*
from	EEH.[dbo].[WOHeadersNew] with (READUNCOMMITTED)
GO

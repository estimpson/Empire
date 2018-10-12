SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[mold] as
select	*
from	EEH.[dbo].[mold] with (READUNCOMMITTED)
GO

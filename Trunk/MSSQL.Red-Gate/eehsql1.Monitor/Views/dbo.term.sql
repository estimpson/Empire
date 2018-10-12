SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[term] as
select	*
from	EEH.[dbo].[term] with (READUNCOMMITTED)
GO

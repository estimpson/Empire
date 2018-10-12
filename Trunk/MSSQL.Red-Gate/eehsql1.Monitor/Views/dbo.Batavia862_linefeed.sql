SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Batavia862_linefeed] as
select	*
from	EEH.[dbo].[Batavia862_linefeed] with (READUNCOMMITTED)
GO

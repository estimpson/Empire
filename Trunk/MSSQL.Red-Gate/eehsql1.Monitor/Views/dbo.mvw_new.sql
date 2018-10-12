SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[mvw_new] as
select	*
from	EEH.[dbo].[mvw_new] with (READUNCOMMITTED)
GO

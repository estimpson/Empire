SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[View_1] as
select	*
from	EEH.[dbo].[View_1] with (READUNCOMMITTED)
GO

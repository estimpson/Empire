SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[labor] as
select	*
from	EEH.[dbo].[labor] with (READUNCOMMITTED)
GO

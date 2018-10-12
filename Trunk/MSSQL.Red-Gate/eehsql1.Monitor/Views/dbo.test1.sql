SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[test1] as
select	*
from	EEH.[dbo].[test1] with (READUNCOMMITTED)
GO

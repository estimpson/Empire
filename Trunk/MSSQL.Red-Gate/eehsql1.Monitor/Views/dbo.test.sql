SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[test] as
select	*
from	EEH.[dbo].[test] with (READUNCOMMITTED)
GO

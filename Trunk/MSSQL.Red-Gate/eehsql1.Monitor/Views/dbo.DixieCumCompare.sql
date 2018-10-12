SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[DixieCumCompare] as
select	*
from	EEH.[dbo].[DixieCumCompare] with (READUNCOMMITTED)
GO

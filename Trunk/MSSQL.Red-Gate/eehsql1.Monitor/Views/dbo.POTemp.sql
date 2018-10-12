SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[POTemp] as
select	*
from	EEH.[dbo].[POTemp] with (READUNCOMMITTED)
GO

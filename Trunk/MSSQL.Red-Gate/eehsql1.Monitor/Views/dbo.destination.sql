SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[destination] as
select	*
from	EEH.[dbo].[destination] with (READUNCOMMITTED)
GO

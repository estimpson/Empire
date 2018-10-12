SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[commodity] as
select	*
from	EEH.[dbo].[commodity] with (READUNCOMMITTED)
GO

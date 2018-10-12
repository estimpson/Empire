SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[link] as
select	*
from	EEH.[dbo].[link] with (READUNCOMMITTED)
GO

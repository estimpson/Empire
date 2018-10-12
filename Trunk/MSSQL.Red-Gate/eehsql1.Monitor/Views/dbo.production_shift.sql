SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[production_shift] as
select	*
from	EEH.[dbo].[production_shift] with (READUNCOMMITTED)
GO

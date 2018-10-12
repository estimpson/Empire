SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[BorrarSerie] as
select	*
from	EEH.[dbo].[BorrarSerie] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Query_CantidadScrap] as
select	*
from	EEH.[dbo].[Query_CantidadScrap] with (READUNCOMMITTED)
GO

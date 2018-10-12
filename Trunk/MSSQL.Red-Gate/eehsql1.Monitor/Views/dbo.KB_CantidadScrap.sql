SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[KB_CantidadScrap] as
select	*
from	EEH.[dbo].[KB_CantidadScrap] with (READUNCOMMITTED)
GO

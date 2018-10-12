SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ciclico] as
select	*
from	EEH.[dbo].[ciclico] with (READUNCOMMITTED)
GO

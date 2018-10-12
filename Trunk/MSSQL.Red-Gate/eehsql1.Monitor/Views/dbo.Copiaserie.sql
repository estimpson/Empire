SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Copiaserie] as
select	*
from	EEH.[dbo].[Copiaserie] with (READUNCOMMITTED)
GO

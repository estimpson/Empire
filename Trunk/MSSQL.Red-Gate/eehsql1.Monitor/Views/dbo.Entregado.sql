SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Entregado] as
select	*
from	EEH.[dbo].[Entregado] with (READUNCOMMITTED)
GO

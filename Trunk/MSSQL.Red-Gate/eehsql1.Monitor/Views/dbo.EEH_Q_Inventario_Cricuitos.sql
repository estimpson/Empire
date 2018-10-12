SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[EEH_Q_Inventario_Cricuitos] as
select	*
from	EEH.[dbo].[EEH_Q_Inventario_Cricuitos] with (READUNCOMMITTED)
GO

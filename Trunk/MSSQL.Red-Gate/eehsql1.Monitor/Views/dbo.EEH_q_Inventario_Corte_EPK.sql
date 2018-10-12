SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[EEH_q_Inventario_Corte_EPK] as
select	*
from	EEH.[dbo].[EEH_q_Inventario_Corte_EPK] with (READUNCOMMITTED)
GO

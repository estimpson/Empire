SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[VW_CP_Contenedores_Futuros_Active] as
select	*
from	EEH.[HN].[VW_CP_Contenedores_Futuros_Active] with (READUNCOMMITTED)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[CP_Revisiones_Produccion_asignacion] as
select	*
from	sistema.dbo.CP_Revisiones_Produccion_Asignacion with (readuncommitted, nolock)
GO

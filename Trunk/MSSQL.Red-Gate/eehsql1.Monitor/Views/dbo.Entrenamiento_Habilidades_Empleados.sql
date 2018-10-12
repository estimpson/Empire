SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Entrenamiento_Habilidades_Empleados] as
select	*
from	Sistema.dbo.Entrenamiento_Habilidades_Empleados with(readuncommitted)
GO

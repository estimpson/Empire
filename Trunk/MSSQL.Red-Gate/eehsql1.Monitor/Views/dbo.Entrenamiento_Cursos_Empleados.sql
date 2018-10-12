SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Entrenamiento_Cursos_Empleados] as
select	*
from	Sistema.dbo.Entrenamiento_Cursos_Empleados with(readuncommitted)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Entrenamiento_Cursos] as
select	*
from	Sistema.dbo.Entrenamiento_Cursos with (readuncommitted)
GO

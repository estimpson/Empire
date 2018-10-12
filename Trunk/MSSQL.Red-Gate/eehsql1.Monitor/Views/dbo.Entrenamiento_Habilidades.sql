SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Entrenamiento_Habilidades] as
select	*
from	Sistema.dbo.Entrenamiento_Habilidades with(readuncommitted)
GO

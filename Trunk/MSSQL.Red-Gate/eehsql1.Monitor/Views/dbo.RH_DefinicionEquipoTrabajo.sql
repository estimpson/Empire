SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_DefinicionEquipoTrabajo]
AS


SELECT        EquipoTrabajoID, EquipoDescripcion, EsPerecedero, TiempoExpiracionEnDias, CreadoPor, CreadoFecha, ValidarEnSistemaHuella
FROM           Sistema.dbo.RH_DefinicionEquipoTrabajo



--SELECT        NivelEducID, Descripcion_Nivel
--FROM            RH_NivelEducativo
--ORDER BY Descripcion_Nivel



GO

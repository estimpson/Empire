SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_GruposFocales_Detalle]
AS


SELECT        id, GrupoFocalID, TemaID, QuejaID, Responsable, PlandeAccion, Status, FechaCierre
FROM            Sistema.dbo.RRHH_GruposFocales_Detalle




GO

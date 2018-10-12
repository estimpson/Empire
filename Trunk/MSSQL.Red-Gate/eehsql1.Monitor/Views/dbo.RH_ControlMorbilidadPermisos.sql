SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_ControlMorbilidadPermisos]
AS

SELECT     RH_ControlMorbilidad.ID, RH_ControlMorbilidad.EmpleadoID, RH_ControlMorbilidad.Obervacion, RH_ControlMorbilidad.Causa, RH_ControlMorbilidad.Fecha, RH_ControlMorbilidad.Duracion_1, 
                      RH_ControlMorbilidad.Motivo, RH_ControlMorbilidad.CausaPermisoID,
                          (SELECT     CASE RH_ControlMorbilidad.Duracion WHEN 0 THEN 'Dias' ELSE 'Horas' END AS Expr1) AS Duracion, RH_ControlMorbilidad.Cant_Duracion,
                          (SELECT     CASE RH_ControlMorbilidad.TipoPermiso WHEN 1 THEN 'Programado' ELSE 'No Programado' END AS Expr1) AS TipoPermiso, 
                      RH_ControlMorbilidad.RemitidoSistema, RH_CausaPermiso.Descripcion
FROM         Sistema.dbo.RH_ControlMorbilidad RH_ControlMorbilidad LEFT OUTER JOIN
                      Sistema.dbo.RH_CausaPermiso RH_CausaPermiso ON RH_ControlMorbilidad.CausaPermisoID = RH_CausaPermiso.CausaPermisoID



--SELECT        NivelEducID, Descripcion_Nivel
--FROM            RH_NivelEducativo
--ORDER BY Descripcion_Nivel



GO

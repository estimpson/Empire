SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SME_DetalleRequisisiones] 
	@fecha as date
AS
BEGIN
/*
	exec SME_DetalleRequisisiones '2017-10-26'
*/

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
SELECT        x.RequestId, x.CentroCosto, x.Area, x.Aplicacion, x.commodity, x.CuentaId, x.RequestMonto, x.Motivo, x.FechaAprobacion, y.RequestPartePrecio, y.RequestLineaCantidad, 
                         y.RequestPartePrecio * y.RequestLineaCantidad AS TotalDetale, y.ParteId
FROM            (SELECT DISTINCT 
                                                    COGZ_RequestHeader.RequestId, vw_COGZ_EstructuraDepartamento.Name AS Area, COGZ_Aplicaciones.AplicacionNombre AS Aplicacion, COGZ_RequestHeader.CentroCosto, 
                                                    COGZ_RequestHeader.commodity, COGZ_RequestHeader.CuentaId, COGZ_RequestHeader.RequestMonto, COGZ_TipoSolicitudes.TipoSolicitudDescripcion AS Motivo, 
                                                    COGZ_TipoSolicitudes_1.TipoSolicitudDescripcion AS Adquirido, COGZ_RequestHeader.RequestCreadoEl, COGZ_RequestHeader.RequestStatus, COGZ_RequestHeader.RequestTurno, nota, 
                                                    FechaAprobado.FechaAprobacion, EntregadoEl, 'Normales' AS Tipo
                          FROM            sistema.dbo.COGZ_RequestHeader INNER JOIN
                                                    sistema.dbo.COGZ_Aplicaciones ON COGZ_RequestHeader.AplicacionId = COGZ_Aplicaciones.AplicacionId INNER JOIN
                                                    sistema.dbo.vw_COGZ_EstructuraDepartamento ON COGZ_RequestHeader.RequestArea = vw_COGZ_EstructuraDepartamento.OptionID INNER JOIN
                                                    sistema.dbo.COGZ_TipoSolicitudes ON COGZ_RequestHeader.MotivoId = COGZ_TipoSolicitudes.TipoSolicitudId INNER JOIN
                                                    sistema.dbo.COGZ_TipoSolicitudes AS COGZ_TipoSolicitudes_1 ON COGZ_RequestHeader.LugarAdquisicion = COGZ_TipoSolicitudes_1.TipoSolicitudId LEFT OUTER JOIN
                                                    sistema.dbo.COGZ_RequestAprobadores ON COGZ_RequestAprobadores.RequestId = COGZ_RequestHeader.RequestId LEFT OUTER JOIN
                                                        (SELECT        RequestId, MAX(AprobadoEl) AS FechaAprobacion
                                                          FROM            sistema.dbo.COGZ_RequestAprobadores AS COGZ_RequestAprobadores_3
                                                          GROUP BY RequestId
                                                          HAVING         (MAX(AprobadoEl) IS NOT NULL)) AS FechaAprobado ON COGZ_RequestHeader.RequestId = FechaAprobado.RequestId
                          WHERE        (DATEDIFF(d, FechaAprobado.FechaAprobacion, @fecha) = 0) AND (CapexExcedido <> 1)
                          UNION ALL
                          SELECT DISTINCT 
                                                   COGZ_RequestHeader.RequestId, vw_COGZ_EstructuraDepartamento.Name AS Area, COGZ_Aplicaciones.AplicacionNombre AS Aplicacion, COGZ_RequestHeader.CentroCosto, 
                                                   COGZ_RequestHeader.commodity, COGZ_RequestHeader.CuentaId, COGZ_RequestHeader.RequestMonto, COGZ_TipoSolicitudes.TipoSolicitudDescripcion AS Motivo, 
                                                   COGZ_TipoSolicitudes_1.TipoSolicitudDescripcion AS Adquirido, COGZ_RequestHeader.RequestCreadoEl, COGZ_RequestHeader.RequestStatus, COGZ_RequestHeader.RequestTurno, nota, 
                                                   FechaAprobado.FechaAprobacion, EntregadoEl, 'Excedidas' AS Tipo
                          FROM            sistema.dbo.COGZ_RequestHeader AS COGZ_RequestHeader INNER JOIN
                                                   sistema.dbo.COGZ_Aplicaciones AS COGZ_Aplicaciones ON COGZ_RequestHeader.AplicacionId = COGZ_Aplicaciones.AplicacionId INNER JOIN
                                                   sistema.dbo.vw_COGZ_EstructuraDepartamento AS vw_COGZ_EstructuraDepartamento ON COGZ_RequestHeader.RequestArea = vw_COGZ_EstructuraDepartamento.OptionID INNER JOIN
                                                   sistema.dbo.COGZ_TipoSolicitudes AS COGZ_TipoSolicitudes ON COGZ_RequestHeader.MotivoId = COGZ_TipoSolicitudes.TipoSolicitudId INNER JOIN
                                                   sistema.dbo.COGZ_TipoSolicitudes AS COGZ_TipoSolicitudes_1 ON COGZ_RequestHeader.LugarAdquisicion = COGZ_TipoSolicitudes_1.TipoSolicitudId LEFT OUTER JOIN
                                                   sistema.dbo.COGZ_RequestAprobadores AS COGZ_RequestAprobadores_2 ON COGZ_RequestAprobadores_2.RequestId = COGZ_RequestHeader.RequestId LEFT OUTER JOIN
                                                       (SELECT        RequestId, MAX(AprobadoEl) AS FechaAprobacion
                                                         FROM            sistema.dbo.COGZ_RequestAprobadores AS COGZ_RequestAprobadores_1
                                                         GROUP BY RequestId
                                                         HAVING         (MAX(AprobadoEl) IS NOT NULL)) AS FechaAprobado ON COGZ_RequestHeader.RequestId = FechaAprobado.RequestId
                          WHERE        (CapexExcedido = 1) AND (DATEDIFF(d, FechaAprobado.FechaAprobacion, @fecha) = 0)) AS x INNER JOIN
                         sistema.dbo.COGZ_RequestDetail AS y ON x.RequestId = y.RequestId
END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_HistoricoEstado]
AS


SELECT        id, Empleadoid, FechaInicio, FechaFinal, Observacion, EstadoAnterior, EstadoActual, HoraFechaIngreso, Usuario
FROM            Sistema.dbo.RH_HistoricoEstado



GO

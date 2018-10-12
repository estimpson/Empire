SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_Incidentes]
AS



SELECT        ID, EmpleadoID, Motivo, Medida, IngresadoPor, Fecha, Observacion, Dias
FROM            Sistema.dbo.RH_Incidentes



GO

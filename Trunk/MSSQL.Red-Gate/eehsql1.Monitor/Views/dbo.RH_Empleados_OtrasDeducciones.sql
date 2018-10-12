SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[RH_Empleados_OtrasDeducciones]
AS

SELECT DeduccionID, EmpleadoId, DescripciondelMonto, Saldo, CuotaADeducir, FechaInicioDeduccion, Usuario, ValorOriginal 
--select * 
FROM Sistema.dbo.RH_Empleados_OtrasDeducciones


--SELECT        NivelEducID, Descripcion_Nivel
--FROM            RH_NivelEducativo
--ORDER BY Descripcion_Nivel



GO
